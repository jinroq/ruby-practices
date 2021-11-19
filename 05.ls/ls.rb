#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

# Ls クラス
class Ls
  # ファイルタイプのマスク定数
  MASK_FILETYPE = 0o770000

  # ファイルタイプのビットフラグ
  OCT_FILETYPE_FIFO              = 0o010000
  OCT_FILETYPE_CHARACTER_SPECIAL = 0o020000
  OCT_FILETYPE_DIRECTORY         = 0o040000
  OCT_FILETYPE_BLOCK_SPECIAL     = 0o060000
  OCT_FILETYPE_FILE              = 0o100000
  OCT_FILETYPE_LINK              = 0o120000
  OCT_FILETYPE_SOCKET            = 0o140000

  # ファイルタイプの記号
  CHR_FILETYPE_FIFO              = 'p'
  CHR_FILETYPE_CHARACTER_SPECIAL = 'c'
  CHR_FILETYPE_DIRECTORY         = 'd'
  CHR_FILETYPE_BLOCK_SPECIAL     = 'b'
  CHR_FILETYPE_FILE              = '-'
  CHR_FILETYPE_LINK              = 'l'
  CHR_FILETYPE_SOCKET            = 's'

  # SGID、SUID、スティッキービットのマスク定数
  MASK_OTHERWISE = 0o007000

  # SGID、SUID、スティッキービットのビットフラグ
  OCT_SUID      = 0o004000
  OCT_SGID      = 0o002000
  OCT_STICKYBIT = 0o001000

  # SGID、SUID、スティッキービットの記号
  CHR_STICKYBIT   = 't'
  CHR_STICKYBIT_L = 'T'
  CHR_SGID        = 's'
  CHR_SGID_L      = 'S'
  CHR_SUID        = 's'
  CHR_SUID_L      = 'S'

  # パーミッションのマスク定数
  MASK_OWNER_PERMISSION = 0o000700
  MASK_GROUP_PERMISSION = 0o000070
  MASK_OTHER_PERMISSION = 0o000007

  # パーミッションのビットフラグ
  OCT_READABLE_PERMISSION   = 0o4
  OCT_WRITABLE_PERMISSION   = 0o2
  OCT_EXECUTABLE_PERMISSION = 0o1
  OCT_NON_PERMISSION        = 0o0

  # パーミッションの記号
  CHR_READABLE_PERMISSION   = 'r'
  CHR_WRITABLE_PERMISSION   = 'w'
  CHR_EXECUTABLE_PERMISSION = 'x'
  CHR_NON_PERMISSION        = '-'

  # 1 KiB
  ONE_KIBIBYTE = 1024

  def initialize
    opt = OptionParser.new
    params = {}

    opt.on('-a') { |v| params[:a] = v }
    opt.on('-r') { |v| params[:r] = v }
    opt.on('-l') { |v| params[:l] = v }
    opt.parse!(ARGV)

    @files = params[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @files = @files.reverse if params[:r]
    @list_flag = params[:l]
  end

  def run
    lines = create_lines
    puts_list(lines)
  end

  private

  def create_lines(columns = 3)
    files = @files
    length = files.length
    filesize = 0

    lines = @list_flag ? [] : Array.new(length / columns) { [] }
    if @list_flag
      files.each do |file|
        filestat   = File.lstat(File.absolute_path(file))
        filemode   = filestat.mode
        filetype   = _chr_filetype(filemode)
        permission = _permission(filemode)
        time       = filestat.mtime
        size       = FileTest.size(File.absolute_path(file))

        filesize += size
        lines.push(filetype +
                   permission +
                   ' ' +
                   (filetype == CHR_FILETYPE_DIRECTORY ? '2' : '1') +
                   ' ' +
                   Etc.getpwuid(filestat.uid).name +
                   ' ' +
                   Etc.getgrgid(filestat.uid).name +
                   ' ' +
                   size.to_s +
                   ' ' +
                   time.strftime("%Y年 %_m月 %_d %_H:%S") +
                   ' ' +
                   file)
      end

      lines.unshift("合計 #{filesize/ONE_KIBIBYTE}")
    else
      max_line = lines.length

      files.each_with_index do |file, i|
        lines[i % max_line].push(file)
      end
    end

    lines
  end

  def _chr_filetype(filemode)
    filetype = filemode & MASK_FILETYPE

    return CHR_FILETYPE_FIFO              if filetype == OCT_FILETYPE_FIFO
    return CHR_FILETYPE_CHARACTER_SPECIAL if filetype == OCT_FILETYPE_CHARACTER_SPECIAL
    return CHR_FILETYPE_DIRECTORY         if filetype == OCT_FILETYPE_DIRECTORY
    return CHR_FILETYPE_BLOCK_SPECIAL     if filetype == OCT_FILETYPE_BLOCK_SPECIAL
    return CHR_FILETYPE_FILE              if filetype == OCT_FILETYPE_FILE
    return CHR_FILETYPE_LINK              if filetype == OCT_FILETYPE_LINK

    CHR_FILETYPE_SOCKET                 # if filetype == OCT_FILETYPE_SOCKET
  end

  def _permission(filemode)
    otherwise = filemode & MASK_OTHERWISE

    owner_permission = filemode & MASK_OWNER_PERMISSION
    permission = _str_permission(owner_permission >> 6,
                                    { suid: otherwise })
    group_permission = filemode & MASK_GROUP_PERMISSION
    permission += _str_permission(group_permission >> 3,
                                     { sgid: otherwise })
    other_permission = filemode & MASK_OTHER_PERMISSION
    permission += _str_permission(other_permission,
                                     { stickybit: otherwise })

    permission
  end

  def _str_permission(permission, otherwise = {})
    readable   = CHR_NON_PERMISSION
    writable   = CHR_NON_PERMISSION

    readable = CHR_READABLE_PERMISSION if permission & OCT_READABLE_PERMISSION == OCT_READABLE_PERMISSION
    writable = CHR_WRITABLE_PERMISSION if permission & OCT_WRITABLE_PERMISSION == OCT_WRITABLE_PERMISSION
    executable =
      if permission & OCT_EXECUTABLE_PERMISSION == OCT_EXECUTABLE_PERMISSION
        _executable(otherwise)
      else
        _non_executable(otherwise)
      end

    readable + writable + executable
  end

  def _executable(otherwise)
    return CHR_SUID      if otherwise[:suid] == OCT_SUID
    return CHR_SGID      if otherwise[:sgid] == OCT_SGID
    return CHR_STICKYBIT if otherwise[:stickybit] == OCT_STICKYBIT

    CHR_EXECUTABLE_PERMISSION
  end

  def _non_executable(otherwise)
    return CHR_SUID_L      if otherwise[:suid] == OCT_SUID
    return CHR_SGID_L      if otherwise[:sgid] == OCT_SGID
    return CHR_STICKYBIT_L if otherwise[:stickybit] == OCT_STICKYBIT

    CHR_NON_PERMISSION
  end

  def puts_list(lines)
    if @list_flag
      puts lines
    else
      lines.each do |l|
        puts l.join('	')
      end
    end
  end
end

Ls.new.run
