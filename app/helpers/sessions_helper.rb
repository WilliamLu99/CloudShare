module SessionsHelper
    def log_in(user)
        #store the user's id in the browser's cache
        session[:user_id] = user.id
    end
    
    def current_user
        if(@current_user.nil?)
            @current_user = User.find_by(id: session[:user_id]) #return
        else
            @current_user #return
        end
    end
    #Check if user is logged in
    def logged_in?
        !current_user.nil?
    end
    #Log the user out
    def log_out
        session.delete(:user_id) #remove the user id from the browser cache
        @current_user = nil
    end
    #Check if user is logged in, if not redirect them to the home page
    def logged_in_user
      unless logged_in?
        flash[:warning] = "Please log in"
        redirect_to root_url
      end
    end
    #Users can only access thier own profile
    def correct_user
      @user = User.find_by(id: params[:id])
      if(@user.nil?)
        flash[:danger] = "Error. User does not exist"
        redirect_to users_url
      end
      
      #Admins have access to everything
      if(current_user.admin?)
        return true
      end
      
      if( !(@user == current_user))
        flash[:danger] = "You don't have permission to access this page"
        redirect_to root_url
      end
    end
    
    #Check if user is admin
    def admin_user
      if(!current_user.admin?)
        flash[:danger] = "Access Denied. Admin required"
        redirect_to root_url
      end
    end
end
