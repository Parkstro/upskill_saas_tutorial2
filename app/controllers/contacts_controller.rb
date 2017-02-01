class ContactsController < ApplicationController
  
  # Get request to /contact-us
  # Show new contact fomr
   def new
    @contact = Contact.new
   end

  # POST request /contacts
  def create
    # Mass assignment of form fields into contact object
    @contact = Contact.new(contact_params)
    # Save the Contact object to the db
    if @contact.save
      # Store form fields via parameters into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into the contact mailer email method and send
      ContactMailer.contact_email(name, email, body).deliver
      #Store success message in flash hash
      # and redirect to new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # if object doesnt save send error message and redirect
     flash[:danger] = @contact.errors.full_messages.join(", ")
     redirect_to new_contact_path
    end
  end
  
  private
  # To collect data from form, we need to use
  # strong parametrs and whitelist the form fields
    def contact_params
       params.require(:contact).permit(:name, :email, :comments)
    end
end