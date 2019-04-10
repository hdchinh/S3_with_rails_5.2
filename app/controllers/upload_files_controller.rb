class UploadFilesController < ApplicationController
	
	def create_file
		@upload_file = UploadFile.new
	end
	
	def upload_file
		upload_file_to_s3(params[:upload_file][:filename])
    redirect_to root_url
	end

	private

  def s3_bucket
    s3 = AwsResource.for(Aws::S3, region: Rails.application.credentials.s3_region) # connect tới service S3
    s3.bucket(Rails.application.credentials.s3_bucket) # connect tới bucket đã tạo trên S3
  end

	def upload_file_to_s3(upload_file)
    attachment_info = {
      filename: upload_file.original_filename,
      filepath: "nhatduy/#{upload_file.original_filename}", # relative_path trên S3
			filesize: upload_file.size,
			content_type: upload_file.content_type
    }
    decode_filedata = upload_file.read # binary data 
    upload(attachment_info[:filepath], decode_filedata, content_type)
  end

  def upload(filepath, decode_filedata, content_type)
    obj = s3_bucket.object(filepath)
    file_data = {
			body: decode_filedata,
			# tùy chọn mã hóa file tải lên
      server_side_encryption: 'AES256',
      # expires: Time.zone.now.since(15.minute),
      content_type: content_type,
      acl: 'public-read' # Access Control List, ở đây set public-read có nghĩa là file được up lên sẽ public trên môi trường internet, bất cứ ai có thể "nhìn thấy" file này
    }
    obj.put(file_data)
  end
end
