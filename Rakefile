require "fileutils"
require 'tmpdir'
require "net/http"
require "win32/registry"
require 'erb'

$ruby_version = "1.9.3"
$ruby_patch = "392"
$vmc_version = "0.3.23"

$ruby_file_name = "ruby-#{$ruby_version}-p#{$ruby_patch}-i386-mingw32"
$ruby_archive_url = "http://rubyforge.org/frs/download.php/76799/#{$ruby_file_name}.7z"

$sevenzip_command = 'C:\Program Files\7-Zip\7z.exe'
$inno_setup_command = 'C:\Program Files (x86)\Inno Setup 5\iscc'

$proxy_enabled = false
reg_path = 'Software\Microsoft\Windows\CurrentVersion\Internet Settings'
proxy_value = Win32::Registry::HKEY_CURRENT_USER.open(reg_path).read("ProxyServer")
if proxy_value
  $proxy_enabled = true
  $proxy_server, $proxy_port = proxy_value[1].split(":")
  $proxy_port = $proxy_port.to_i
end

$tmpdir = Dir.mktmpdir
$ruby_path =  File.join($tmpdir, $ruby_file_name)

def download_file(to, url, redirect = 10)
  response = ($proxy_enabled ?
              Net::HTTP::Proxy($proxy_server, $proxy_port) :
              Net::HTTP).get_response(URI.parse(url))
  case response
  when Net::HTTPSuccess
    to.puts response.body
  when Net::HTTPRedirection
    download_file(to, response["Location"], redirect - 1)
  else
    raise "Failed to download #{url}"
  end
end

task :download_ruby do
  FileUtils.chdir($tmpdir) do
    archive_name = "ruby.7z"

    puts "Downloading Ruby binary files..."
    open(archive_name, "wb") do |file|
      download_file(file, $ruby_archive_url)
    end

    puts "Extracting Ruby binary files..."
    system("\"#{$sevenzip_command}\" x #{archive_name}")
  end
end

task :install_vmc => :download_ruby do
  set_proxy = ""
  if $proxy_enabled
    set_proxy = "set HTTP_PROXY=http://#{$proxy_server}:#{$proxy_port} &&"
  end

  puts "Installing VMC..."
  FileUtils.chdir(File.join($ruby_path, "bin")) do
    system("#{set_proxy} gem install vmc --version #{$vmc_version}")
  end
end

task :generate_config => :install_vmc do
  output_exe_dir = File.join(FileUtils.pwd, "build")
  ruby_version = $ruby_version
  ruby_patch = $ruby_patch
  ruby_path = $ruby_path
  vmc_version = $vmc_version

  config_file = File.join("src", "config.iss")
  open(config_file, "w") do |file|
    file.puts ERB.new(File.read("#{config_file}.erb")).result(binding)
  end
end

task :default => :generate_config  do
  iss_file = File.join(FileUtils.pwd, "src", "vmcinstaller.iss")
  FileUtils.chdir(File.dirname($inno_setup_command)) do
    system("#{File.basename($inno_setup_command)} \"#{iss_file}\" 2>&1")
  end
end
