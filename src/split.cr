require "walk"

def split_dir(dir : String, max_bytes : UInt64, prefix : String)
  tracker = Hash(Int32, UInt64).new
  current_part = 1
  files_moved = 0
  failed_ops = 0
  base_dir_path = Path.new(dir)

  Walk::Down.new(dir).each do |path|
    next if !File.file?(path)

    size = File.size(path)

    decrement_if_failed = false

    current_part_size = tracker.fetch(current_part, 0)

    if current_part_size > 0 && current_part_size + size > max_bytes
      current_part += 1
      decrement_if_failed = true
    end

    tracker[current_part] = (tracker.has_key?(current_part) ? current_part_size + size : size).to_u64

    part_dir = base_dir_path.join("part#{current_part}")

    new_path = Path.new(path.expand.to_s.sub(
      base_dir_path.expand.to_s,
      part_dir.expand.to_s
    ))

    begin
      Dir.mkdir_p(new_path.parent) if !Dir.exists?(new_path.parent)

      File.rename(path.expand.to_s, new_path.expand.to_s)

      files_moved += 1
    rescue exception
      STDERR.puts exception
      failed_ops += 1
      tracker[current_part] -= size

      current_part -= 1 if decrement_if_failed
    end
  end

  current_part = 0 if files_moved == 0

  puts "Parts created: #{current_part}"
  puts "Files moved: #{files_moved}"
  puts "Failed Operations: #{failed_ops}"

  exit if current_part == 0 || prefix.blank?

  if current_part == 1
    puts %(Tar Command : tar -cf "#{prefix}part1.tar" "part1"; done)
  else
    puts %(Tar Command : for n in {{1..#{current_part}}}; do tar -cf "#{prefix}part$n.tar" "part$n"; done)
  end
end
