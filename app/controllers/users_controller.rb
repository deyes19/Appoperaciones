class UsersController < ApplicationController
  load_and_authorize_resource 

  # GET /users or /users.json
  def index
    @users = User.all
    @actives = Active.where(user_id: current_user.id)
    if params[:query_text].present?
      @users = @users.search_full_text(params[:query_text])
    end
  end
  
  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
    @actives = @user.actives

    @joined_on = @user.created_at.to_formatted_s(:short)
    if @user.current_sign_in_at
      @last_login = @user.current_sign_in_at.to_formatted_s(:short)
    else
      @last_login = 'never'
    end
  end

  def search_active
    @active = Active.find_by(plate: params[:plate])
    if @active
      @actives = [@active]
    else
      flash.now[:alert] = "No se encontró ningún activo con esa placa"
      @actives = []
    end
    render 'search_active'
  end
  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "se creó exitosamente." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end
  
    successfully_updated = if needs_password?(@user, user_params)
                             @user.update(user_params)
                           else
                             @user.update_without_password(user_params)
                           end
  
    if successfully_updated
      redirect_to @user, notice: 'UsEl usuario fue actualizado'
    else
      render :edit
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "Has eliminado al usuario correctamente" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def needs_password?(_user, params)
      params[:password].present?
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(
        :id,
        :email,
        :password,
        :password_confirmation,
        :name,
        :role_id
      )
    end

end
