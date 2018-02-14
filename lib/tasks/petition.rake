goals = [
  500,
  1000,
  2500,
  5000,
  7500,
  10000,
  15000,
  20000,
  25000,
  30000,
  35000,
  40000,
  45000,
  50000
] # stay here until we get to over 70,000 then jump to 100,000

def next_goal(goal)
  goals.each { |g| return g if g > goal }
end

namespace :petition do
  desc "Create a local organizing petition with 99 signatures"
  task create_local: :environment do
    petition = FactoryGirl.create(:local_organizing_petition)

    (0..98).each do |i|
      petition.signatures << FactoryGirl.build(:signature, petition: petition)
      petition.signatures.last.affiliations << FactoryGirl.build(
        :affiliation,
        institution: petition.action_page.institutions[i % 10],
        affiliation_type: petition.action_page.affiliation_types[i % 5]
      )
    end
  end

  desc "Update moving target petition goals"
  task update_goals: :environment do
    Petition.all.each do |petition|
      goal = petition.goal
      count = petition.signatures.count
      if count > goal
        if goal == goals.last
          petition.goal = 100000 if count > 70000
        elsif goal < goals.last
          petition.goal = next_goal(petition.goal)
        end

        if petition.changed?
          petition.save
          print "Petition #{petition.id} updated. Goal: #{petition.goal}\n"
          # TODO: email admins
        end
      end
    end
  end
end
