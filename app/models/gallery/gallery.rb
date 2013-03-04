class Gallery::Gallery < ActiveRecord::Base

  attr_accessible :title, :identifier, :description, :full_width, :full_height, :force_ratio_full, :thumb_width, :thumb_height, :force_ratio_thumb
  
  cms_is_categorized if defined?(ComfortableMexicanSofa)

  self.table_name = :gallery_galleries
  
  # -- Relationships --------------------------------------------------------
  has_many :photos, :dependent => :destroy
  
  # -- Validations ----------------------------------------------------------
  validates :title,
    :presence => true
    
  validates :identifier,
    :presence   => true,
    :uniqueness => true,
    :format     => { :with =>  /^\w[a-z0-9_-]*$/i }
    
end