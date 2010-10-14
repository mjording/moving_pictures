class MovingPictures < Thor                                                
  #map "-L" => :list                                             

  desc "grab HH_MM_SS VIDEO_FILE", "grab image from video file"  
  method_options :output_type => :string, :output_file => :string, :output_size => :string         
  def grab(moment,video_file)
    timesplit = moment.split(':')
    moment_in_seconds = timesplit.first.to_i * 3600 + timesplit[1].to_i * 60 + timesplit.last.to_i
    type = options.output_type? ? options.output_type : "mjpeg"
    if File.exists?(video_file)
      base = File.basename(video_file)
      cmd = "ffmpeg -i #{video_file} -vcodec #{type} -vframes 1 -an -f rawvideo -y -ss #{moment_in_seconds} #{File.basename(video_file).gsub(File.extname(video_file),'.jpeg')}"
      puts cmd
      `#{cmd}`
    else
      puts 'sorry no file by that name'
    end
  end
  
  desc "mp4_transcode VIDEO_FILE", "convert video to mp4 encoded"
  method_options :output_file => :string
  def mp4_transcode(video_file)
    output = options.output_file ? options.output_file : File.basename(video_file).gsub(File.extname(video_file),'.mp4')
    if File.exists?(video_file)
      cmd = "ffmpeg  -i #{video_file} -ar 22050 -f mp4 #{output}"
      puts "executing #{cmd}"
      `#{cmd}`
    else
      puts "error: no file #{video_file}"
    end
  end
  desc "flash_transcode VIDEO_FILE", "convert video to flash encoded"
  method_options :output_file => :string
  def flash_transcode(video_file)
    output = options.output_file ? options.output_file : File.basename(video_file).gsub(File.extname(video_file),'.flv')
    if File.exists?(video_file)
      cmd = "ffmpeg  -i #{video_file} -y -s 640x352 -aspect 640:352 -r 30000/1001 -vcodec flv -pass 1 -b 360k -bt 416k -f flv -acodec libmp3lame -ac 2 -ar 44100 -ab 64k #{output}"
       
      puts "executing #{cmd}"
      `#{cmd}`
    else
      puts "error: no file #{video_file}"
    end
  end
  desc "mov_to_flash MOV_FILE", "convert video from mov to flash encoded"
  method_options :output_file => :string
  def mov_to_flash(mov_file)
    output = options.output_file ? options.output_file : File.basename(mov_file).gsub(File.extname(mov_file),'.flv')
    if File.exists?(mov_file)
      #cmd = "ffmpeg -i #{mov_file} -vcodec libxvid -pass 1 -an -f #{output} -y /dev/null"
      cmd = "ffmpeg  -i #{mov_file} -sameq -ar 44100 -g 640x352 #{output}"
       
      puts "executing #{cmd}"
      `#{cmd}`
    else
      puts "error: no file #{mov_file}"
    end
  end
end
