require "open-uri"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Profile.destroy_all
Place.destroy_all
Workshop.destroy_all
Session.destroy_all
Booking.destroy_all
Review.destroy_all
Animator.destroy_all

puts "DEBUT DE LA SEED
"
puts "--------------------------------"
puts "CREATION DE 3 PARTICIPANTS"

#   ALEXIA : PARTICIPANTE
User.create!(email: 'a@a.com', password: '123456', last_name: 'Dupont', first_name: 'Alexia')
alexia = Profile.last
file = URI.open('https://24.media.tumblr.com/tumblr_m5koiyLN9P1rut9u9o1_500.png')
alexia.photo.attach(io: file, filename: 'alexia.png', content_type: 'image/png')

#   HELOISE : PARTICIPANTE
User.create!(email: 'b@b.com', password: '123456', last_name: 'Janin', first_name: 'Héloïse')
heloise = Profile.last
file = URI.open('https://i.pinimg.com/474x/59/86/69/598669c4a978ce3740c7ce61f18a7c23.jpg')
heloise.photo.attach(io: file, filename: 'heloise.png', content_type: 'image/png')

#   ZOÉ : PARTICIPANTE
User.create!(email: 'c@c.com', password: '123456', last_name: 'Damart', first_name: 'Zoé')
zoe = Profile.last
file = URI.open('https://fr.web.img3.acsta.net/newsv7/19/10/23/12/10/2270700.jpg')
zoe.photo.attach(io: file, filename: 'zoe.jpg', content_type: 'image/jpg')


puts "--------------------------------"
puts "CREATION DE 4 ORGANISATEURS"

# LES HERBES HAUTES : ORGANISATEUR
puts "Organisateur : Les Herbes Hautes"
lesherbeshautes_user = User.create!(email: 'hello@herbes.com', password: '123456', last_name: 'Préchat', first_name: 'Hélène')
lesherbeshautes = Profile.last
lesherbeshautes.update!(
  address: '85 Boulevard Voltaire', zip_code: '75011', city: 'Paris',
  phone_number: '0952090027',
  role: 'Boutique / atelier',
  company: 'Les Herbes Hautes', siret_number: '82397552900020',
  website: 'https://www.lesherbeshautes.fr/',
  instagram: 'https://www.instagram.com/atelier_lesherbeshautes/',
  description: "Les Herbes Hautes est un atelier de création florale, né par amour de la nature. Nous fleurissons avec passion votre mariage et vos événements, en donnant vie à des compositions végétales et fleuries."
  )
file = URI.open('https://www.lesherbeshautes.fr/app/uploads/2020/01/MK4_2725-scaled.jpg')
lesherbeshautes.photo.attach(io: file, filename: 'lesherbeshautes.jpg', content_type: 'image/jpg')

# HAPPY FOLK : ORGANISATEUR
puts "Organisateur : Happy Folk"
happyfolk_user = User.create!(email: 'hello@happy.com', password: '123456', last_name: 'Riera', first_name: 'Nathalie')
happyfolk = Profile.last
happyfolk.update!(
  address: '64 Boulevard Voltaire', zip_code: '75011', city: 'Paris',
  phone_number: '0184790117',
  role: 'Boutique / atelier',
  company: 'Happy Folk', siret_number: '83058659000010',
  website: 'https://www.happyfolk.fr/',
  instagram: 'https://www.instagram.com/happyfolk.fr/',
  description: "Happy Folk est un projet global d’expériences autour de l’art de vivre, de consommer, de travailler Slow basé sur 4 piliers :
  La sélections de créateurs, d’artisans ou de start-up slow de talents, les pratiques de bien-être et médecines douces, les ateliers créatifs Do It Yourself, les conférences et rencontres avec des experts reconnus."
)

file = URI.open("https://res.cloudinary.com/jeudemains/image/upload/v1592745477/mj5b0czoomnt65e810uunwlgw93o.jpg")
happyfolk.photo.attach(io: file, filename: 'happyfolk.jpg', content_type: 'image/jpg')

# LA PETITE EPICERIE : ORGANISATEUR
puts "Organisateur : La Petite Epicerie"
epicerie_user = User.create!(email: 'hello@epicerie.com', password: '123456', last_name: 'Nicoulaud', first_name: 'Laura')
epicerie = Profile.last
epicerie.update!(
  address: '74 Rue de la Verrerie', zip_code: '75004', city: 'Paris',
  phone_number: '0173756518',
  role: 'Boutique / atelier',
  company: 'La Petite Epicerie', siret_number: '82486642000022',
  website: 'https://la-petite-epicerie.fr/fr/',
  instagram: 'https://www.instagram.com/lapetiteepicerie/',
  description: "♥ la Petite épicerie ♥ est une boutique de fournitures de loisirs créatifs.
  Vous y retrouverez tout un tas de cane en pâte Fimo à découper, de chaines, supports bagues ou boucles d'oreille, de vaisselles ou des gourmandises en miniature, de la papeterie, des kits DIY, et bien d'autres produits encore !
  Venez partager un moment convivial et créatif avec d'autres passionnés à l'occasion d'un atelier créatif !"
)
file = URI.open('https://res.cloudinary.com/jeudemains/image/upload/v1592745480/v0tsq8qnkyon5u0e5hrtuomvu9hv.png')
epicerie.photo.attach(io: file, filename: 'la-petite-epicerie.png', content_type: 'image/png')

# LE POP UP DE STELLA : ORGANISATEUR
puts "Organisateur : Le Pop Up de Stella"
stella_user = User.create!(email: 'hello@stella.com', password: '123456', last_name: 'Haumont', first_name: 'Stella')
stella = Profile.last
stella.update!(
  address: '4 rue Jean Brunet', zip_code: '92270', city: 'Bois-Colombes',
  phone_number: '0661439481',
  role: 'Boutique / atelier',
  company: 'Le Pop Up de Stella', siret_number: '82341743100017',
  website: 'https://www.stella-popup-store.com/',
  instagram: 'https://www.instagram.com/le_pop_up_de_stella/',
  description: "Le Pop Up de Stella distille une sélection pointue de petits cadeaux originaux de qualité, fonctionnels et intemporels, pour toute la famille, essentiellement faits à la main par des créateurs d'ici ou d'ailleurs. Nous proposons des ateliers DIY (*Do It Yourself) pour réveiller votre créativité !"
  )
file = URI.open('https://res.cloudinary.com/jeudemains/image/upload/v1592745482/eicboqfmbvrc82q14ep11r4vncmm.jpg')
stella.photo.attach(io: file, filename: 'le-pop-up-de-stella.jpg', content_type: 'image/jpg')


puts "--------------------------------"
puts "CREATION DE 3 ANIMATEURS"

# JULIE WEAVES : ANIMATEUR
puts "Animateur : Julie Weaves"
julieweaves_user = User.create!(email: 'hello@julie.com', password: '123456', last_name: 'Robert', first_name: 'Julie')
julieweaves = Profile.last
julieweaves.update!(
  address: '6 rue Jean Moulin', zip_code: '92400', city: 'Courbevoie',
  phone_number: '0123456788',
  role: "Animation d'ateliers",
  company: 'Julie Weaves', siret_number: '81462020900019',
  website: 'https://www.julie-robert.fr/',
  instagram: 'https://www.instagram.com/julie_weaves/',
  description: 'Julie Robert explore, détourne et valorise des techniques anciennes comme le tissage, la broderie, le point noué et le punch needle à travers ses créations et ses photographies.'
  )
file = URI.open('https://res.cloudinary.com/jeudemains/image/upload/v1592745485/0hil5wr6ku5ztmm4k3oprrmu1lo4.png')
julieweaves.photo.attach(io: file, filename: 'julie-weaves.png', content_type: 'image/png')

# AMELIE'S WORKSHOP : ANIMATEUR
puts "Animateur : Amelie's workshop"
amelie_user = User.create!(email: 'hello@amelie.com', password: '123456', last_name: 'Lee', first_name: 'Amélie')
amelie = Profile.last
amelie.update!(
  address: '', zip_code: '75020', city: 'Paris',
  phone_number: '0123456788',
  role: "Animation d'ateliers",
  company: "Amelie's Workshop", siret_number: '567943843949839',
  website: 'http://ameliesworkshop.fr/',
  instagram: 'https://www.instagram.com/ameliesworkshop/',
  description: 'Amélie’s Workshop, c’est un blog dédié au do it yourself, où tout est fait maison. C’est aussi des ateliers à partager avec vous.
Diplômée d’un master en design graphique et numérique, aussi blogueuse diy & lifestyle à mi-temps, je partage sur mon blog, mes inspirations et mes créations.

Être un couteau suisse créatif, c’est savoir s’enrichir et s’inspirer, développer son style, imaginer des univers et créer du tangible.'
  )
file = URI.open('https://res.cloudinary.com/jeudemains/image/upload/v1592745487/8yojvk6z1ietw5qklndfpstewq6g.jpg')
amelie.photo.attach(io: file, filename: 'amelies-workshop.jpg', content_type: 'image/jpg')

# MY HOME FACTORY : ANIMATEUR
puts "Animateur : My Home Factory"
homefactory_user = User.create!(email: 'hello@factory.com', password: '123456', last_name: 'Gonzales', first_name: 'Charlotte')
homefactory = Profile.last
homefactory.update!(
  address: '', zip_code: '92700', city: 'Colombes',
  phone_number: '01234500044',
  role: "Animation d'ateliers",
  company: "My Home Factory", siret_number: '567943843922222',
  website: 'https://my-homefactory.com/',
  instagram: 'https://www.instagram.com/my_homefactory/',
  description: 'Depuis que je fabrique mes cosmétiques maison, ma vie s’est progressivement transformée. J’ai changé mon alimentation, ma façon de faire les courses, de consommer, bref de voir le monde ! Progressivement, sans le savoir, ni même le vouloir, je me suis tournée vers un mode de vie zéro déchet et beaucoup plus slow.

Aujourd’hui, plus épanouie que jamais grâce à ce nouvel équilibre trouvé, j’ai souhaité partager avec vous ces remèdes qui m’ont permis de trouver un nouveau sens à ma vie.'
  )
file = URI.open('https://res.cloudinary.com/jeudemains/image/upload/v1592808526/zbxex5lhyhq5b7gmc1ga94x0iagz.jpg')
homefactory.photo.attach(io: file, filename: 'my-home-factory.jpg', content_type: 'image/jpg')


puts "--------------------------------"
puts "CREATION DE 6 ADRESSES"

# LES HERBES HAUTES : LIEU
puts "Lieu : Les Herbes Hautes"
place1 = Place.new(
  name: 'Les Herbes Hautes',
  address: '85 Boulevard Voltaire', zip_code: '75011', city: 'Paris',
  phone_number: '0952090027'
  )
place1.user = lesherbeshautes_user
place1.save!

# HAPPY FOLK : LIEU
puts "Lieu : Happy Folk"
place2 = Place.new(
  name: 'Happy Folk',
  address: '64 Boulevard Voltaire', zip_code: '75011', city: 'PARIS',
  phone_number: '0184790117'
  )
place2.user = happyfolk_user
place2.save!

# LA PETITE EPICERIE : 3 LIEUX
puts "Lieux (x3) : La Petite Epicerie"
place3 = Place.new(
  name: 'La Petite Epicerie, Paris 4e',
  address: '74 Rue de la Verrerie', zip_code: '75004', city: 'PARIS',
  phone_number: '0173756518'
  )
place3.user = epicerie_user
place3.save!

place4 = Place.new(
  name: "La Petite Epicerie, Chaussée d'Antin",
  address: "47 Rue de la Chaussée d'Antin", zip_code: '75009', city: 'PARIS',
  phone_number: '0171379844'
  )
place4.user = epicerie_user
place4.save!

place5 = Place.new(
  name: "La Petite Epicerie, Vincennes",
  address: "71 Rue de Fontenay", zip_code: '94300', city: 'Vincennes',
  phone_number: '0187361688'
  )
place5.user = epicerie_user
place5.save!

# L'APPARTEMENT DU SLOW' : LIEU
puts "Lieu : L'appartement du slow"
place6 = Place.new(
  name: "L'appartement du slow",
  address: "2 rue Turgot", zip_code: '75009', city: 'Paris',
  phone_number: '0661439481',
  )
place6.user = stella_user
place6.save!


puts "--------------------------------"
puts "CREATION DE 12 ATELIERS"

# LES HERBES HAUTES - COURONNE DE FLEURS
puts "Atelier : Couronne de fleurs"
workshop1 = Workshop.new(
  title: 'Couronne en fleurs éternelles',
  program: 'Vous souhaitez créer votre propre couronne en fleurs éternelles pour votre mariage, celui d’une amie, ou simplement pour vous faire plaisir? Cet atelier DIY de 2h est fait pour vous !

Nous vous guiderons pour réaliser une création esthétique et raffinée. Repartez fièrement avec votre propre création pour orner votre joli minois. Les fleurs stabilisées et séchées se gardent des années… Idéales pour un souvenir impérissable !',
  final_product: 'Repartez fièrement avec votre propre couronne de fleurs.',
  thematic: 'Végétal',
  level: 'Débutant',
  duration: 120,
  price: 69.00,
  status: 'en ligne',
  capacity: 6,
  ephemeral: false,
  verified: true
  )
workshop1.place = place1
workshop1.save!

# LES HERBES HAUTES - TERRARIUM
puts "Atelier : Terrarium"
workshop2 = Workshop.new(
  title: 'Créez votre terrarium',
  program: 'Pendant cet atelier d’1h30-2h, vous apprendrez à composer ces petites merveilles de la nature. Rassurez-vous, Hélène et Elise seront là pour vous guider : choix du contenant, des plantes, de la terre, sables, végétaux. N’hésitez pas à prendre note des petites astuces d’entretien qu’elles vous glisseront… et repartez fièrement avec votre propre création. Avec tout ça, impossible de se planter !

Que vous ayez la main verte ou pas, suivez les conseils de nos passionnées du monde végétal et devenez l’artisan de votre propre terrarium. Laissez parler votre créativité en façonnant vous-même votre petit écosystème !',
  final_product: 'Repartez fièrement avec votre propre terrarium.',
  thematic: 'Végétal',
  level: 'Débutant',
  duration: 90,
  price: 79.00,
  status: 'en ligne',
  capacity: 8,
  ephemeral: false,
  verified: true
  )
workshop2.place = place1
workshop2.save!

# LES HERBES HAUTES - BOUQUET FLEURS SECHEES
puts "Atelier : Bouquet fleurs sechees"
workshop3 = Workshop.new(
  title: 'Bouquet de fleurs séchées',
  program: 'Vous souhaitez créer votre propre bouquet en fleurs éternelles pour donner une touche déco et durable à votre maison? Cet atelier DIY d’1h30 est fait pour vous !

Nous vous guiderons pour réaliser une création esthétique et raffinée. Repartez fièrement avec votre propre bouquet durable pour sublimer votre intérieur.',
  final_product: 'Repartez fièrement avec votre bouquet de fleurs séchées.',
  thematic: 'Végétal',
  level: 'Débutant',
  duration: 90,
  price: 59.00,
  status: 'en ligne',
  capacity: 8,
  ephemeral: false,
  verified: true
  )
workshop3.place = place1
workshop3.save!

# HAPPY FOLK - JULIE WEAVES - TISSAGE MURAL
puts "Atelier : Tissage mural"
workshop4 = Workshop.new(
  title: 'Réalisez un tissage mural',
  program: 'Vous avez remarqué que le tissage fait des émules sur Pinterest ? Bonne nouvelle, Seize organise des ateliers pour débutantes !
Un après-midi cocooning pour apprendre à tisser sur métier en mixant les textures et les coloris ! Au programme de ce stage intensif de trois heures : le montage de la trame, les bases du tissage et quelques jolies techniques pour réaliser des torsades, des tresses et même des franges ! Et pour que votre réalisation soit la plus élégante possible, nous vous avons concocté une belle sélection de matières, y compris de la mèche XXL !
Matériel inclus',
  final_product: 'Repartez fièrement avec votre création tissage mural.',
  thematic: 'Autour du fil',
  level: 'Débutant',
  duration: 150,
  price: 79.00,
  status: 'en ligne',
  capacity: 9,
  ephemeral: false,
  verified: true
  )
workshop4.place = place2
animator1 = Animator.new
animator1.workshop = workshop4
animator1.user = julieweaves_user
animator1.save!
workshop4.save!

# APPARTEMENT DU SLOW - JULIE WEAVES - TISSAGE MURAL
puts "Atelier : Tissage mural 2"
workshop5 = Workshop.new(
  title: 'Réalisez un tissage mural',
  program: 'Vous avez remarqué que le tissage fait des émules sur Pinterest ? Bonne nouvelle, Seize organise des ateliers pour débutantes !
Un après-midi cocooning pour apprendre à tisser sur métier en mixant les textures et les coloris ! Au programme de ce stage intensif de trois heures : le montage de la trame, les bases du tissage et quelques jolies techniques pour réaliser des torsades, des tresses et même des franges ! Et pour que votre réalisation soit la plus élégante possible, nous vous avons concocté une belle sélection de matières, y compris de la mèche XXL !
Matériel inclus',
  final_product: 'Repartez fièrement avec votre création tissage mural.',
  thematic: 'Autour du fil',
  level: 'Débutant',
  duration: 150,
  price: 79.00,
  status: 'en ligne',
  capacity: 5,
  ephemeral: true,
  verified: true
  )
workshop5.place = place6
animator2 = Animator.new
animator2.workshop = workshop5
animator2.user = julieweaves_user
animator2.save!
workshop5.save!

# PETITE EPICERIE LIEU 1 - AMELIE'S WORKSHOP - LETTERING & AQUARELLE
puts "Atelier : Lettering & aquarelle 1"
workshop6 = Workshop.new(
  title: 'Initiez-vous aux Lettering & aquarelle',
  program: "Apprendre le lettering, c'est redécouvrir les bases de la calligraphie en y ajoutant une touche de modernité. Lors de cet atelier, Amélie vous apprendra à tenir un brush pen (ou feutre pinceau), à dessiner des lettres puis à compoer des phrases, citations ou simplement votre prénom. Vous pourrez ensuite réaliser de jolis lettrages sur vos cartes de voeux ou dans votre bullet journal !
En 2e temps, elle vous initiera à l'aquarelle, pour apprendre à dessiner et peindre des couronnes et bouquets de fleurs, qui viendront sublimer vos lettrages.",
  final_product: 'Repartez fièrement avec votre oeuvre sur papier.',
  thematic: 'Papier & Lettering',
  level: 'Débutant',
  duration: 120,
  price: 35.00,
  status: 'en ligne',
  capacity: 10,
  ephemeral: false,
  verified: true
  )
workshop6.place = place3
animator3 = Animator.new
animator3.workshop = workshop6
animator3.user = amelie_user
animator3.save!
workshop6.save!

# PETITE EPICERIE LIEU 2 - AMELIE'S WORKSHOP - LETTERING & AQUARELLE
puts "Atelier : Lettering & aquarelle 2"
workshop7 = Workshop.new(
  title: 'Initiez-vous aux Lettering & aquarelle',
  program: "Apprendre le lettering, c'est redécouvrir les bases de la calligraphie en y ajoutant une touche de modernité. Lors de cet atelier, Amélie vous apprendra à tenir un brush pen (ou feutre pinceau), à dessiner des lettres puis à compoer des phrases, citations ou simplement votre prénom. Vous pourrez ensuite réaliser de jolis lettrages sur vos cartes de voeux ou dans votre bullet journal !
En 2e temps, elle vous initiera à l'aquarelle, pour apprendre à dessiner et peindre des couronnes et bouquets de fleurs, qui viendront sublimer vos lettrages.",
  final_product: 'Repartez fièrement avec votre oeuvre sur papier.',
  thematic: 'Papier & Lettering',
  level: 'Débutant',
  duration: 120,
  price: 35.00,
  status: 'en ligne',
  capacity: 8,
  ephemeral: true,
  verified: true
  )
workshop7.place = place4
animator4 = Animator.new
animator4.workshop = workshop7
animator4.user = amelie_user
animator4.save!
workshop7.save!

# PETITE EPICERIE LIEU 3 - AMELIE'S WORKSHOP - LETTERING & AQUARELLE
puts "Atelier : Lettering & aquarelle 3"
workshop8 = Workshop.new(
  title: 'Initiez-vous aux Lettering & aquarelle',
  program: "Apprendre le lettering, c'est redécouvrir les bases de la calligraphie en y ajoutant une touche de modernité. Lors de cet atelier, Amélie vous apprendra à tenir un brush pen (ou feutre pinceau), à dessiner des lettres puis à compoer des phrases, citations ou simplement votre prénom. Vous pourrez ensuite réaliser de jolis lettrages sur vos cartes de voeux ou dans votre bullet journal !
En 2e temps, elle vous initiera à l'aquarelle, pour apprendre à dessiner et peindre des couronnes et bouquets de fleurs, qui viendront sublimer vos lettrages.",
  final_product: 'Repartez fièrement avec votre oeuvre sur papier.',
  thematic: 'Papier & Lettering',
  level: 'Débutant',
  duration: 120,
  price: 35.00,
  status: 'en ligne',
  capacity: 6,
  ephemeral: false,
  verified: true
  )
workshop8.place = place5
animator5 = Animator.new
animator5.workshop = workshop8
animator5.user = amelie_user
animator5.save!
workshop8.save!

# HAPPY FOLK - AMELIE'S WORKSHOP - LETTERING & AQUARELLE
puts "Atelier : Lettering & aquarelle 4"
workshop9 = Workshop.new(
  title: 'Initiez-vous aux Lettering & aquarelle',
  program: "Apprendre le lettering, c'est redécouvrir les bases de la calligraphie en y ajoutant une touche de modernité. Lors de cet atelier, Amélie vous apprendra à tenir un brush pen (ou feutre pinceau), à dessiner des lettres puis à compoer des phrases, citations ou simplement votre prénom. Vous pourrez ensuite réaliser de jolis lettrages sur vos cartes de voeux ou dans votre bullet journal !
En 2e temps, elle vous initiera à l'aquarelle, pour apprendre à dessiner et peindre des couronnes et bouquets de fleurs, qui viendront sublimer vos lettrages.",
  final_product: 'Repartez fièrement avec votre oeuvre sur papier.',
  thematic: 'Papier & Lettering',
  level: 'Débutant',
  duration: 120,
  price: 35.00,
  status: 'en ligne',
  capacity: 6,
  ephemeral: false,
  verified: true
  )
workshop9.place = place2
animator6 = Animator.new
animator6.workshop = workshop9
animator6.user = amelie_user
animator6.save!
workshop9.save!

# APPARTEMENT DU SLOW - MY HOME FACTORY - COSMETIQUES SOLIDES
puts "Atelier : Cosmétiques solides"
workshop10 = Workshop.new(
  title: 'Vos cosmétiques zéro déchet',
  program: "En 1h30, cet atelier vous propose d’apprendre à réaliser trois produits de votre salle de bain en version zéro déchet : un shampoing, un déodorant et un dentifrice.
1. Connaître les règles d'hygiène de la cosmétique maison
2. Découvrir les ingrédients utilisés et leurs propriétés
3. Réaliser les trois produits.
Tous les ingrédients et le matériel sont fournis. Cet atelier est réalisé dans une démarche éco responsable, les ingrédients sont naturels et principalement bio.",
  final_product: "Bénéficiez de conseils personnalisés et repartez avec un pochon en tissu cousu par Charlotte, vos réalisations ainsi que les recettes.",
  thematic: 'Cosmétique & Entretien',
  level: 'Débutant',
  duration: 90,
  price: 49.00,
  status: 'en ligne',
  capacity: 7,
  ephemeral: true,
  verified: true
  )
workshop10.place = place6
animator7 = Animator.new
animator7.workshop = workshop10
animator7.user = homefactory_user
animator7.save!
workshop10.save!

# LA PETITE EPICERIE - MY HOME FACTORY - COSMETIQUES SOLIDES
puts "Atelier : Cosmétiques solides 2"
workshop11 = Workshop.new(
  title: 'Vos cosmétiques zéro déchet',
  program: "En 1h30, cet atelier vous propose d’apprendre à réaliser trois produits de votre salle de bain en version zéro déchet : un shampoing, un déodorant et un dentifrice.
1. Connaître les règles d'hygiène de la cosmétique maison
2. Découvrir les ingrédients utilisés et leurs propriétés
3. Réaliser les trois produits.
Tous les ingrédients et le matériel sont fournis. Cet atelier est réalisé dans une démarche éco responsable, les ingrédients sont naturels et principalement bio.",
  final_product: "Bénéficiez de conseils personnalisés et repartez avec un pochon en tissu cousu par Charlotte, vos réalisations ainsi que les recettes.",
  thematic: 'Cosmétique & Entretien',
  level: 'Débutant',
  duration: 90,
  price: 49.00,
  status: 'en ligne',
  capacity: 10,
  ephemeral: false,
  verified: true
  )
workshop11.place = place3
animator8 = Animator.new
animator8.workshop = workshop11
animator8.user = homefactory_user
animator8.save!
workshop11.save!

# APPARTEMENT DU SLOW - MY HOME FACTORY - CREME VISAGE ET SERUM
puts "Atelier : crème visage et serum"
workshop12 = Workshop.new(
  title: 'Beauté du visage crème et sérum',
  program: "Ces deux soins personnalisés suffiront pour nourrir et embellir votre visage. En 1h30, vous apprendrez à réaliser une crème visage et un sérum huileux.
1. Connaître les règles d'hygiène de la cosmétique maison
2. Découvrir les ingrédients d’une crème visage et d’un sérum
3. Personnaliser les recettes en fonction de vos problématiques
4. Apprendre les étapes d’une émulsion
Tous les ingrédients et le matériel sont fournis. Cet atelier est réalisé dans une démarche éco responsable, les ingrédients sont naturels et principalement bio et les contenants en verre.",
  final_product: "Bénéficiez de conseils personnalisés de Charlotte en fonction de votre type de peau et de ses astuces pour une routine beauté du visage simple et efficace. Repartez avec vos réalisations ainsi que les recettes.",
  thematic: 'Cosmétique & Entretien',
  level: 'Débutant',
  duration: 90,
  price: 49.00,
  status: 'en ligne',
  capacity: 7,
  ephemeral: true,
  verified: true
  )
workshop12.place = place6
animator9 = Animator.new
animator9.workshop = workshop12
animator9.user = homefactory_user
animator9.save!
workshop12.save!


puts "--------------------------------"
puts "CREATION DE 21 SESSIONS"

# LES HERBES HAUTES - COURONNE DE FLEURS
puts "Sessions atelier couronne de fleurs"
workshop1_session1 = Session.new(
  date: Date.today + 30,
  start_at: '14h00'
)
workshop1_session1.workshop = workshop1
workshop1_session1.capacity = workshop1_session1.workshop.capacity
workshop1_session1.save!

workshop1_session2 = Session.new(
  date: Date.today + 45,
  start_at: '10h00'
)
workshop1_session2.workshop = workshop1
workshop1_session2.capacity = workshop1_session1.workshop.capacity
workshop1_session2.save!


# LES HERBES HAUTES - TERRARIUM - PAS DE DATE


# LES HERBES HAUTES - BOUQUET FLEURS SECHEES
puts "Sessions atelier bouquet fleurs sechees"
workshop3_session1 = Session.new(
  date: Date.today + 15,
  start_at: '10h00'
)
workshop3_session1.workshop = workshop3
workshop3_session1.capacity = workshop3_session1.workshop.capacity
workshop3_session1.save!

workshop3_session2 = Session.new(
  date: Date.today + 40,
  start_at: '17h00'
)
workshop3_session2.workshop = workshop3
workshop3_session2.capacity = workshop3_session2.workshop.capacity
workshop3_session2.save!


# JULIE WEAVES - TISSAGE MURAL
puts "Sessions atelier tissage mural"
workshop4_session1 = Session.new(
  date: Date.today + 16,
  start_at: '18h00'
)
workshop4_session1.workshop = workshop4
workshop4_session1.capacity = workshop4_session1.workshop.capacity
workshop4_session1.save!

workshop4_session2 = Session.new(
  date: Date.today + 33,
  start_at: '18h00'
)
workshop4_session2.workshop = workshop4
workshop4_session2.capacity = workshop4_session2.workshop.capacity
workshop4_session2.save!


# JULIE WEAVES - TISSAGE MURAL 2
puts "Sessions atelier tissage mural 2"
workshop5_session1 = Session.new(
  date: Date.today + 70,
  start_at: '15h00'
)
workshop5_session1.workshop = workshop5
workshop5_session1.capacity = workshop5_session1.workshop.capacity
workshop5_session1.save!

workshop5_session2 = Session.new(
  date: Date.today + 71,
  start_at: '15h00'
)
workshop5_session2.workshop = workshop5
workshop5_session2.capacity = workshop5_session2.workshop.capacity
workshop5_session2.save!

workshop5_session3 = Session.new(
  date: Date.today + 72,
  start_at: '15h00'
)
workshop5_session3.workshop = workshop5
workshop5_session3.capacity = workshop5_session3.workshop.capacity
workshop5_session3.save!


# AMELIES WORKSHOP - LETTERING & AQUARELLE
puts "Sessions atelier lettering & aquarelle"
workshop6_session1 = Session.new(
  date: Date.today + 25,
  start_at: '17h00'
)
workshop6_session1.workshop = workshop6
workshop6_session1.capacity = workshop6_session1.workshop.capacity
workshop6_session1.save!

puts "Sessions atelier lettering & aquarelle 2"
workshop7_session1 = Session.new(
  date: Date.today + 30,
  start_at: '17h00'
)
workshop7_session1.workshop = workshop7
workshop7_session1.capacity = workshop7_session1.workshop.capacity
workshop7_session1.save!

puts "Sessions atelier lettering & aquarelle 3"
workshop8_session1 = Session.new(
  date: Date.today + 35,
  start_at: '17h00'
)
workshop8_session1.workshop = workshop8
workshop8_session1.capacity = workshop8_session1.workshop.capacity
workshop8_session1.save!

puts "Sessions atelier lettering & aquarelle 4"
workshop9_session1 = Session.new(
  date: Date.today + 10,
  start_at: '18h00'
)
workshop9_session1.workshop = workshop9
workshop9_session1.capacity = workshop9_session1.workshop.capacity
workshop9_session1.save!

workshop9_session2 = Session.new(
  date: Date.today + 40,
  start_at: '18h00'
)
workshop9_session2.workshop = workshop9
workshop9_session2.capacity = workshop9_session2.workshop.capacity
workshop9_session2.save!


# MY HOMEFACTORY - COSMETIQUE
puts "Sessions atelier cosmetique zero dechet"
workshop10_session1 = Session.new(
  date: Date.today + 70,
  start_at: '18h00'
)
workshop10_session1.workshop = workshop10
workshop10_session1.capacity = workshop10_session1.workshop.capacity
workshop10_session1.save!

workshop10_session2 = Session.new(
  date: Date.today + 71,
  start_at: '18h00'
)
workshop10_session2.workshop = workshop10
workshop10_session2.capacity = workshop10_session2.workshop.capacity
workshop10_session2.save!

workshop10_session3 = Session.new(
  date: Date.today + 72,
  start_at: '18h00'
)
workshop10_session3.workshop = workshop10
workshop10_session3.capacity = workshop10_session3.workshop.capacity
workshop10_session3.save!

puts "Sessions atelier cosmetique zero dechet 2"
workshop11_session1 = Session.new(
  date: Date.today + 52,
  start_at: '15h00'
)
workshop11_session1.workshop = workshop11
workshop11_session1.capacity = workshop11_session1.workshop.capacity
workshop11_session1.save!

workshop11_session2 = Session.new(
  date: Date.today + 52,
  start_at: '15h00'
)
workshop11_session2.workshop = workshop11
workshop11_session2.capacity = workshop11_session2.workshop.capacity
workshop11_session2.save!

puts "Sessions atelier beauté visage"
workshop12_session1 = Session.new(
  date: Date.today + 70,
  start_at: '12h00'
)
workshop12_session1.workshop = workshop12
workshop12_session1.capacity = workshop12_session1.workshop.capacity
workshop12_session1.save!

workshop12_session2 = Session.new(
  date: Date.today + 71,
  start_at: '12h00'
)
workshop12_session2.workshop = workshop12
workshop12_session2.capacity = workshop1_session2.workshop.capacity
workshop12_session2.save!

puts "--------------------------------"
puts "FIN"
puts "enfin la fin de cette trop longue seed sans avis car je n'ai pas créé de bookings"

