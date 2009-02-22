class ModelsObserver < ActiveRecord::Observer

  observe Company, User, Breed, Groomer, PetOwner, Pet, Appointment

  def after_save(model)
    model.logger.info("Audit: #{model.class.name} #{model.id} created")
  end
end
