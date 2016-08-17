# class ImportInstitutionsJob < ActiveJob::Base
#   queue_as :medium_priority

#   def perform(csv, action_page)
#     Institution.import(csv, action_page)
#   end
# end