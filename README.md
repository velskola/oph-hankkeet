# Visualize Educational Development Statistics

This repository forms a part of a Junction 2020 submission.


## Background and problem

The Finnish National Agency for Education (Opetushallitus) provides funding for
2,500-3,500 education development projects on a yearly basis. On each one of
these projects, there are vast amounts of data provided in the form of a final
report, which includes e.g. objectives and results. Yet, there is no concise way
to sort and review data on the projects.


## The solution

Our team decided to build a dashboard concept to make the available project data
visual and easily accessible. This repository holds the code components of the
dashboard concept.


# Tools


## Data dump tool

`tools/data_dump_tool.rb` is a small Ruby script to convert the [Junction challenge data dump][1] into tabular CSV format.

[1]: https://valtionavustukset.oph.fi/api/junction-hackathon/dump


## Organization data

`organizations/municipality_numbers.json` contains municipality numbers for educational organizations.
 
The data is sourced from Opetushallitus organisaatio-service:

    https://virkailija.opintopolku.fi/organisaatio-service/rest/organisaatio/v4/hierarkia/hae?aktiiviset=true&suunnitellut=true&lakkautetut=true&skipParents=false
    
And parsed with the `organizations/municipality_numbers.rb` script.
