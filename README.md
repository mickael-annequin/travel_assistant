Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.


cd ~/code/<ton-pseudo>/travel_assistant
git status                  # 1. rien en cours ? sinon commit ta branche d'abord
git checkout master         # 2. tu te places sur master
git pull origin master      # 3. tu récupères tous les merges de l'équipe
bundle install              # 4. au cas où quelqu'un a ajouté une gem
rails db:migrate            # 5. au cas où quelqu'un a ajouté une migration
git checkout -b chat        # 6. nouvelle branche pour ta feature
rails db:seed               # 7. Pour créer les seeds


