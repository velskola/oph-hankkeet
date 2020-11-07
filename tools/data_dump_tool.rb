#!/usr/bin/env ruby

require 'csv'
require 'json'


INPUT_FILE = 'dump.json'
OUTPUT_FILE = 'flat_data.csv'


def read_data(file)
  raw_data = JSON.parse(File.read(file))
  haut = raw_data['haku'].map { |h| [h['id'], h] }.to_h
  raw_data['loppuselvitys']
      .group_by { |ls| ls['haku_id'] }
      .each { |id, vals| haut[id]['loppuselvitykset'] = vals }
  haut
end

def process(data)
  data.values.flat_map do |haku|
    form = haku['loppuselvitys_form'].map { |f| f['children'] }.compact.reduce([], :concat).concat(haku['loppuselvitys_form'])
    loppuselvitykset = haku['loppuselvitykset']
    loppuselvitykset.map do |loppuselvitys|
      answers = loppuselvitys['loppuselvitys_answers']['value']
      {
          hanke: haku.dig('content', 'name', 'fi'),
          alku: haku.dig('content', 'duration', 'start'),
          loppu: haku.dig('content', 'duration', 'end'),
          organisaatio: loppuselvitys['organization_name'],
          projekti: loppuselvitys['project_name'],
          qa: join_qa(form, answers)
      }
    end
  end
end

def join_qa(form, answers)
  answers.map do |answer|
    form_key = answer['key']
    next if form.nil?
    subform = form.find { |element| element['id'] == form_key }
    next if subform.nil?
    label = subform.dig('label', 'fi')
    answer_val = answer['value']
    content = if answer_val.is_a?(Array)
                join_qa(subform['children'], answer_val)
              else
                answer_val
              end
    {
        question: label,
        answer: content
    }
  end
end

def flatten_qa(qas, context = [])
  return if qas.nil?
  question = qas[:question]
  answer = qas[:answer]
  if answer.is_a?(Array)
    answer.flat_map { |a| flatten_qa(a, context + [question]) }
  else
    [{
        context: context.find_all { |x| !x.nil? && !x.empty? }.join(', '),
        question: question,
        answer: answer
    }]
  end
end

csv_columns = [
    'Hanke',
    'Alku',
    'Loppu',
    'Organisaatio',
    'Projekti',
    'Kysymyksen konteksti',
    'Kysymys',
    'Vastaus'
]

puts "Reading from #{INPUT_FILE}"
flat_data = process(read_data(INPUT_FILE)).flat_map do |r|
  r[:qa].compact.flat_map do |qas|
    flatten_qa(qas).compact.map do |qa|
      [
          r[:hanke],
          r[:alku],
          r[:loppu],
          r[:organisaatio],
          r[:projekti],
          qa[:context],
          qa[:question],
          qa[:answer]
      ]
    end
  end
end

CSV.open(OUTPUT_FILE, 'wb') do |csv|
  [csv_columns].concat(flat_data).each do |row|
    if row.length != 8
      raise 'Invalid data'
    end
    csv << row
  end
end
puts "CSV data written to #{OUTPUT_FILE}"
