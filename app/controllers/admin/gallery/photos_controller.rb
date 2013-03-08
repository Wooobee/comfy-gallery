class Admin::Gallery::PhotosController < Admin::Gallery::BaseController
  
  before_filter :load_gallery
  before_filter :load_photo,  :only => [:edit, :update, :destroy, :crop]
  before_filter :build_photo, :only => [:new, :create]

  def index
    @photos = @gallery.photos
  end

  def new
    render
  end
  
  def create
    file_array  = params[:gallery_photo][:image] || [nil]
    
    file_array.each_with_index do |file, i|
      file_params = params[:gallery_photo].merge(:image => file)
      
      title = (file_params[:title].blank? && file_params[:image] ? 
        file_params[:image].original_filename : 
        file_params[:title]
      )
      title = title + " #{i + 1}" if file_params[:title] == title && file_array.size > 1
      
      @photo = Gallery::Photo.new({:gallery => @gallery}.merge(file_params.merge(:title => title) || {}))
      @photo.save!
    end
    
    flash[:notice] = 'Foto cadastrada'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash[:error] = 'Erro ao cadastrar a foto'
    render :action => :new
  end
  
  def edit
    render
  end
  
  def update
    @photo.update_attributes!(params[:gallery_photo])
    flash[:notice] = 'Foto atualizada'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Erro ao atualizar a foto'
    render :action => :edit
  end
  
  def destroy
    @photo.destroy
    flash[:notice] = 'Foto excluida'
    redirect_to :action => :index
  end
  
  def reorder
    (params[:gallery_photo] || []).each_with_index do |id, index|
      if (photo = Gallery::Photo.find_by_id(id))
        photo.update_attribute(:position, index)
      end
    end
    render :nothing => true
  end
  
  def crop
    render
  end
  
protected
  
  def load_gallery
    @gallery = Gallery::Gallery.find(params[:gallery_id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Galeria não encontrada'
    redirect_to admin_gallery_galleries_path
  end
  
  def load_photo
    @photo = @gallery.photos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Foto não encontrada'
    redirect_to :action => :index
  end
  
  def build_photo
    @photo = Gallery::Photo.new({:gallery => @gallery}.merge(params[:sofa_gallery_photo] || {}))
  end
  
end
