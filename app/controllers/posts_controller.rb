class PostsController < ApplicationController
  def index
    @posts = @user.posts.order('updated_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    params_f = posts_params
    uploaded_io = params_f[:image]
    image_id = nil
    if(uploaded_io)
      im = uploaded_io.read
      correct_img = image_type(im[0,10])
      if correct_img == 'etc'
        render action: 'new'
        return false
      end
      path = Rails.root.join('app','assets','images','photos', @user.id.to_s).to_s
      #dirname = File.dirname(path)
      unless File.directory?(path)
        FileUtils.mkdir_p(path)
      end
      filename = SecureRandom.urlsafe_base64+"_"+uploaded_io.original_filename
      File.open(path+"/"+filename,'wb') do |file|
        file.write(im)
      end
      image_rec = Image.create(original_name: uploaded_io.original_filename, local: 'assets/photos/'+@user.id.to_s+"/"+filename)
      image_rec.save
      image_id = image_rec.id
    end
    @post = Post.create(user_id: posts_params[:user_id], content: posts_params[:content], image_id: image_id)
    if @post.save
      redirect_to posts_url
    else
      render action: 'new'
    end
  end

  def show
    @permission = false
    @post = Post.find(params[:id])
    if @post.user_id == @user.id or @user.friends.exists?(id: @post.user_id)
      @permission = true
    else
      @post = nil
      @permission = false
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.image_id
      image = Image.find(@post.image_id)
      image.destroy
    end
    @post.destroy
    redirect_to posts_path
  end

  private
  def posts_params
    params.require(:post).permit(:user_id, :content, :image)
  end
  def image_type(header)
    png = Regexp.new("\x89PNG".force_encoding("binary"))
    jpg = Regexp.new("\xff\xd8".force_encoding("binary"))
    case header
    when /^GIF8/
      'gif'
    when /^#{png}/
      'png'
    when /^#{jpg}/
      'jpg'
    else
      'etc'
    end 
  end
end
