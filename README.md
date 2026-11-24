Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.


cd ~/code/<ton-pseudo>/travel_assistant
git status                  # 1. rien en cours ? sinon commit ta branche d'abord
git checkout master         # 2. tu te places sur master
git pull origin master      # 3. tu récupères tous les merges de l'équipe
bundle install              # 4. au cas où quelqu'un a ajouté une gem
rails db:migrate            # 5. au cas où quelqu'un a ajouté une migration
git checkout -b chat        # 6. nouvelle branche pour ta feature
rails db:seed               # 7. Pour créer les seeds

------------------------------

Étape 1 : brancher RubyLLM

Ajouter gem "ruby_llm" dans le Gemfile, puis bundle install. ✅
Mettre la clé API dans le fichier .env (OPENAI_API_KEY=...) et vérifier que .env est dans le .gitignore. La clé ne doit jamais partir sur GitHub. En équipe, chacun met la clé dans son propre .env. ✅
Créer config/initializers/ruby_llm.rb avec le bloc RubyLLM.configure du cours. ✅
Test dans rails c : RubyLLM.chat.ask("Bonjour").content doit renvoyer une réponse. ✅

Étape 2 : les associations
has_many :messages, dependent: :destroy dans Trip, belongs_to :trip dans Message. ✅
Test : Trip.first.messages dans rails c (avec les seeds). ✅

Étape 3 : afficher la conversation sur la page show

Boucle sur @trip.messages dans la vue, avec un affichage différent selon le role.
Le formulaire simple_form_for [@trip, @message], avec @message = Message.new dans trips#show.
Test : les 2 messages des seeds s'affichent.

Étape 4 : la route imbriquée
resources :messages, only: :create à l'intérieur de resources :trips do ... end.

Étape 5 : MessagesController#create, le cœur du chat, en quatre temps :

Retrouver le trip avec params[:trip_id].
Enregistrer le message de l'utilisateur (role: "user").
Appeler RubyLLM avec with_instructions(...) et .ask(...).
Enregistrer la réponse (role: "assistant"), puis redirect_to vers la page du trip.

Test : tu poses une question, la réponse apparaît.

Étape 6 : le prompt

Un system prompt construit avec les 4 piliers : Persona (guide de voyage), Context, Task, Format.
Le contexte du trip ajouté aux instructions : destination, dates, centres d'intérêt, « other ». C'est l'équivalent du challenge_context du cours. Sans lui, l'IA ne sait rien du voyage.

Étape 7 : les premières recommandations à la création du trip
C'est votre fonctionnalité principale : dans trips#create, après le save, appeler le LLM une première fois et enregistrer sa réponse comme premier message assistant. L'utilisateur arrive alors sur la page show avec des propositions déjà affichées.

Étape 8 : le rendu Markdown
Gems, helper render_markdown, raw(...) dans la vue.

Une limite à connaître : avec le code du cours, le LLM ne reçoit que le dernier message. Il ne se souvient pas de la conversation. C'est ce que traite le cours Conversational UX de demain.
