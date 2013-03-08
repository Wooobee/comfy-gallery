class Admin::Gallery::GalleriesController < Admin::Gallery::BaseController
  
  before_filter :load_gallery,  :except => [:index, :new, :create]
  before_filter :build_gallery, :only   => [:new, :create]
  
  def index
    if params[:category].present?
      @galleries = Gallery::Gallery.for_category(params[:category]).all
    else
      @galleries = Gallery::Gallery.all
    end
  end
  
  def new
    render
  end
  
  def create
    @gallery.save!
    flash[:notice] = 'Galeria cadastrada'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Erro ao cadastrar a galeria'
    render :action => :new
  end
  
  def show
    render
  end
  
  def edit
    render
  end
  
  def update
    @gallery.update_attributes!(params[:gallery])
    flash[:notice] = 'Galeria atualizada'
    redirect_to :action => :index
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Erro ao atualizar a galeria'
    render :action => :edit
  end
  
  def destroy
    @gallery.destroy
    flash[:notice] = 'Galeria excluida'
    redirect_to :action => :index
  end
  
protected
  
  def load_gallery
    @gallery = Gallery::Gallery.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Galeria não encontrada'
    redirect_to :action => :index
  end
  
  def build_gallery
    @gallery = Gallery::Gallery.new(params[:gallery])
  end
  
end
