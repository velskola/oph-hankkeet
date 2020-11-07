#!/usr/bin/env ruby

require 'json'


SOURCE_FILE = 'organization_hierarchy.json'


def parse_org(organization)
  name = organization.dig('nimi', 'fi')
  municipality_number = organization['kotipaikkaUri'].sub('kunta_', '')

  if name.nil?
    municipality = nil
  else
    municipality = {
        name: name,
        kunta: municipality_number
    }
  end

  children = organization['children'].flat_map { |child| parse_org(child) }

  [municipality].concat(children)
end

data = JSON.parse(File.read(SOURCE_FILE))
municipality_numbers = data['organisaatiot']
                           .flat_map { |organization| parse_org(organization) }
                           .compact
                           .group_by { |e| e[:name] }
                           .map { |name, values| [name, values.map { |value| value[:kunta] }.uniq] }
                           .to_h
                           .sort_by { |k, _v| k }
                           .to_h

File.write('municipality_numbers.json', JSON.pretty_generate(municipality_numbers))
