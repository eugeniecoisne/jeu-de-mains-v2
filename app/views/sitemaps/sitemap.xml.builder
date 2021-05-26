base_url = "https://#{request.host_with_port}/"

xml.instruct! :xml, :version=>"1.0"
xml.tag! 'urlset', 'xmlns' => 'https://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url do
    xml.loc base_url
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'ateliers.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'devenir-partenaire.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'offrir-une-carte-cadeau.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'entreprises.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'a-propos.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'nous-contacter.html'
    xml.priority 1.0
  end
  @workshops.each do |workshop|
    xml.url do
      xml.loc workshop_url(workshop)
      xml.priority 1.0
      xml.lastmod Time.at(workshop.updated_at).iso8601(9)
    end
  end
  @partners.each do |partner|
    xml.url do
      xml.loc profile_public_url(partner)
      xml.priority 1.0
      xml.lastmod Time.at(partner.updated_at).iso8601(9)
    end
  end
  xml.url do
    xml.loc base_url+'vegetal.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'autour-du-fil.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'cosmetique-et-entretien.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'papier-et-calligraphie.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'ceramique-et-modelage.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'bijoux.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'peinture-et-dessin.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'meuble-et-decoration.html'
    xml.priority 1.0
  end
  xml.url do
    xml.loc base_url+'travail-du-cuir.html'
    xml.priority 1.0
  end

end
