require_relative 'metro_system'

def main
  file_path = ARGV[0]
  if file_path.nil?
    puts 'Please Enter a file'
  elsif File.exist? file_path
    metro_system = MetroSystem.new
    File.open(file_path).each_line do |line|
      arr = line.split(' ')
      metro_system.send(arr[0].downcase, *arr[1..-1])
    end
  else
    puts 'File does not exists'
  end
end

main
