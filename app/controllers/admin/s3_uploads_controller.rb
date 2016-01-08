class Admin::S3UploadsController < Admin::ApplicationController

  # GET /admin/source_files
  # GET /admin/source_files.json
  def index
    @source_files = SourceFile.all.order('created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @source_files.map(&:to_jq_upload) }
    end
  end

  # POST /admin/source_files
  # POST /admin/source_files.json
  def create
    # this line allows for compatibility with `ProtectedAttributes` or `StrongParameters`
    parameters = S3CorsFileupload.active_record_protected_attributes? ? params[:source_file] : params.require(:source_file).permit(:url, :bucket, :key)
    @source_file = SourceFile.new(parameters)
    respond_to do |format|
      if @source_file.save
        format.html {
          render :json => @source_file.to_jq_upload,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: @source_file.to_jq_upload, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @source_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/source_files/1
  # DELETE /admin/source_files/1.json
  def destroy
    @source_file = SourceFile.find(params[:id])
    @source_file.destroy

    respond_to do |format|
      format.html { redirect_to source_files_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end

  # used for s3_uploader on the javascript of the upload to gallery section
  # for /admin/action_page/new
  # GET /admin/source_files/generate_key
  def generate_key
    uid = SecureRandom.uuid.gsub(/-/,'')

    render json: {
      key: "uploads/#{uid}/#{params[:filename]}",
      success_action_redirect: "/"
    }
  end
end
