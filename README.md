# Visualize Educational Development Statistics


## Organization data

`organizations/municipality_numbers.json` contains municipality numbers for educational organizations.
 
The data is sourced from Opetushallitus organisaatio-service:

    https://virkailija.opintopolku.fi/organisaatio-service/rest/organisaatio/v4/hierarkia/hae?aktiiviset=true&suunnitellut=true&lakkautetut=true&skipParents=false
    
And parsed with the `organizations/municipality_numbers.rb` script.


## Tools

### Data dump tool

`tools/data_dump_tool.rb` is a small script to convert the Junction challenge
[data dump][1] into tabular CSV format.

[1]: https://valtionavustukset.oph.fi/api/junction-hackathon/dump
