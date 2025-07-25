class Admin::SourceFilesController < Admin::ApplicationController
  before_action :set_source_files, only: %i(index create destroy)

  def index
    @upload = SourceFile.new
  end

  def create
    @upload = SourceFile.new(source_file_params)
    if @upload.save
      redirect_to action: "index", notice: "Image successfully uploaded"
    else
      flash[:error] = "Upload failed: #{@upload.errors}"
      set_source_files
      render "index"
    end
  end

  def destroy
    @source_file = SourceFile.find(params[:id])
    @source_file.destroy
    render "index"
  end

  private

  def set_source_files
    @source_files = if params[:f].present?
                      SourceFile.search_by_name(params[:f])
                    else
                      SourceFile.limit(12)
                    end
  end

  def source_file_params
    params.require(:source_file)
          .permit(:image, :file_name)
  end
end
