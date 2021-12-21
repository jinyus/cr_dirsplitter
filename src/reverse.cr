require "walk"

def reverse_split(dir : String)
  base_dir_path = Path.new(dir).expand

  part_dirs_to_delete = [] of Path

  should_delete = true

  Dir.new(base_dir_path).each_child do |file|
    path = base_dir_path.join(file)
    is_part_dir = File.directory?(path) && /part\d+/.matches?(file)

    if !is_part_dir
      next
    end

    part_dirs_to_delete << path

    Walk::Down.new(path).each do |inner_file|
      if !File.file?(inner_file)
        next
      end
      dest = Path.new(
        inner_file.expand.to_s.sub(
          path.to_s,
          base_dir_path.to_s
        )
      )

      begin
        if !Dir.exists?(dest.parent)
          Dir.mkdir_p(dest.parent)
        end

        File.rename(inner_file.expand.to_s, dest.to_s)
      rescue exception
        STDERR.puts exception
        should_delete = false
      end
    end
  end

  if part_dirs_to_delete.empty?
    STDERR.puts "no part directory found"
    exit
  end

  if should_delete
    part_dirs_to_delete.each do |part|
      #   puts part
      safe_delete(part)
    end
  end
end

# recurisively delete a tree of empty directories
def safe_delete(dir : Path, delete_parent = false)
  if Dir.empty?(dir)
    Dir.delete(dir)
  else
    Dir.new(dir).each_child do |child|
      safe_delete(dir.join(child))
      safe_delete(dir)
    end
  end
end
