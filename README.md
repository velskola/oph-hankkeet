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

`tools/map_data_generator.ipynb` is a script for combining municipality numbers with hanke organization names and costs extracted from the challenge data dump. The municipality numbers are then used for plotting cost and other data with mapcolorizer[2]

[1]: https://valtionavustukset.oph.fi/api/junction-hackathon/dump
[2]: https://github.com/tomimick/mapcolorizer
