`import DS from "ember-data";`

Paragraph = DS.Model.extend
  document: DS.belongsTo('document', {async: true})
  selections: DS.hasMany('selection', {async: true})

  text: DS.attr()
  tagName: DS.attr()

Paragraph.reopenClass
  FIXTURES: [
    { id: 1, document: 1, tagName: 'p', text: 'JV: Ok. So how do you commute between the campus and your house.'}
    { id: 2, document: 1, tagName: 'p', text: "P1: So on the weekdays I take the bus, hum, there is a bus that stops right in front of my house, so it's very convenient. And the on the weekends, parking on campus is free after noon on Saturdays and Sundays. So if I'm going to campus on the weekends I usually just drive, especially because the 67, the bus that I usually take doesn't run on the weekend, so, I got to take my car."}
    { id: 3, document: 1, tagName: 'p', text: "JV: Is it paid by the university?"}
    { id: 4, document: 1, tagName: 'p', text: "P1: So, for taking the bus, hum, included in my tuition every quarter is a 76 dollar fee for a commute pass, and the includes unlimited use of public transportation, like the bus or the light rail, so, I technically paid for it in my tuition, but it's, you know, also, kind of sponsored by the university."}
  ]

`export default Paragraph;`