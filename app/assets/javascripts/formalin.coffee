React = require 'react'
cfx = require 'coffeex'

inc = (->
  num = 0
  (-> ++num)
)()

class Input extends React.Component
  constructor: (props) ->
    super props
    @schema = @props.schema
  render: -> @template this

class TextInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.input '.form-control',
        type: 'text'
        name: @schema.name
        defaultValue: @props.value
        placeholder: @schema.placeholder

class ParagraphInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.textarea '.form-control',
        rows: (@schema.rows or 3)
        name: @schema.name
        defaultValue: @props.value
        placeholder: @schema.placeholder

class ChoiceInput extends Input
  isSelected: (value) ->
    [].concat(@props.value || []).indexOf(value) isnt -1

class MultiCheckInput extends ChoiceInput
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      for choice in @schema.choices
        $.div '.checkbox', ->
          $.label ->
            $.input
              name: "#{@schema.name}[]"
              type: 'checkbox'
              value: choice.value
              defaultChecked: @isSelected(choice.value)
            _ if choice.label? then choice.label else choice.value

class RadioInput extends ChoiceInput
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      for choice in @schema.choices
        $.div '.radio', ->
          $.label ->
            $.input
              name: "#{@schema.name}"
              type: 'radio'
              value: choice.value
              defaultChecked: @isSelected(choice.value)
            _ if choice.label? then choice.label else choice.value

class SelectInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.select '.form-control',
        name: @schema.name
        defaultValue: @props.value, ->
          for choice in @schema.choices
            $.option
              value: choice.value,
              if choice.label? then choice.label else choice.value

class NumberInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.input '.form-control',
        type: 'number'
        name: @schema.name
        defaultValue: @props.value
        placeholder: @schema.placeholder

class Formaline extends React.Component
  constructor: (props) ->
    super props

  switchInput: (input) ->
    switch input.type
      when 'text'       then TextInput
      when 'number'     then NumberInput
      when 'multicheck' then MultiCheckInput
      when 'radio'      then RadioInput
      when 'select'     then SelectInput
      when 'paragraph'  then ParagraphInput
      when 'table'      then TableInput

  template: cfx ($, _) ->
    $.form ->
      for child, i in @props.schema
        $ @switchInput(child),
          schema: child
          value: @props.value[child.name]

  render: -> @template this

class TableCellInput extends Input
  handleChange: ->
    @props.onChange.apply null, arguments

class TableTextInput extends TableCellInput
  template: cfx ($, _) ->
    $.input '.form-control',
      type: 'text'
      name: @schema.nestedName
      defaultValue: @props.value
      placeholder: @schema.placeholder
      onChange: @handleChange.bind(this)

class TableNumberInput extends TableCellInput
  template: cfx ($, _) ->
    $.input '.form-control',
      type: 'number'
      name: @schema.nestedName
      defaultValue: @props.value
      placeholder: @schema.placeholder
      onChange: @handleChange.bind(this)

class TableSelectInput extends TableCellInput
  template: cfx ($, _) ->
    $.select '.form-control',
      name: @schema.nestedName
      onChange: @handleChange.bind(this)
      defaultValue: @props.value, ->
        for choice in @schema.choices
          $.option
            value: choice.value,
            choice.label

class TableInput extends Input
  constructor: (props) ->
    super props
    @state =
      value: @props.value.map (row) ->
        row._key = inc()
        row
  
  switchInput: (input) ->
    switch input.type
      when 'text'       then TableTextInput
      when 'number'     then TableNumberInput
      when 'select'     then TableSelectInput

  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.dl '.dl-horizontal', ->
        for child in @schema.children
          if child.note?
            $.dt child.title
            $.dd child.note
      $.table '.table', ->
        $.tbody ->
          $.tr key: 'header', ->
            $.th -> _ '#'
            for child in @schema.children
              $.th child.title
            $.th '削除'
          for value, i in @state.value
            $.tr key: value._key, ->
              $.th "#{i+1}"
              for child in @schema.children
                $.td key: child.name, ->
                  nestedName = "#{@schema.name}[#{i}][#{child.name}]"
                  $ @switchInput(child),
                    schema: Object.create(child, nestedName: { value: nestedName })
                    value: value[child.name]
                    onChange: @handleChange.bind(this, i, child.name)
              $.td ->
                $.button '.btn.btn-danger',
                  type: 'button',
                  onClick: @removeRow.bind(this, i), ->
                    $.span '.glyphicon.glyphicon-remove', ariaHidden: true
          $.tr key: 'footer', ->
            $.td '.text-center', colSpan: @schema.children.length+2, ->
              $.button '.btn.btn-success',
                type: 'button',
                onClick: @addRow.bind(this), ->
                  $.span '.glyphicon.glyphicon-plus', ariaHidden: true

  handleChange: (i, name, event) ->
    @state.value[i][name] = event.target.value
    @setState @state

  removeRow: (i) ->
    @state.value.splice i, 1
    @setState @state

  addRow: ->
    initialValue = {}
    for child in @schema.children
      initialValue[child.name] = child.default
      initialValue._key = inc()

    @setState {
      value: @state.value.concat([initialValue])
    }

data = {
  many: [
    { name: 'アレ', count: 10 }
    { name: 'ソレ', count: 100 }
  ]
  name: 'ほげ'
  desc: 'ほげほげあ'
  select1: 'val2'
  select2: 'val1'
  select3: 'val1'
}

schema = [
  {
    name: 'many'
    type: 'table'
    title: '複数可'
    note: '複数書ける'

    children: [
      {
        name: 'name'
        type: 'text'
        title: '物品名'
        note: '物の名前'
      },
      {
        name: 'count'
        type: 'number'
        title: '個数'
        note: '個数ですね'
        default: 0
      },
      {
        name: 'select4'
        type: 'select'
        title: 'なんか選ぶ'
        default: 0

        choices: [
          { value: 'hoi', label: 'ほい' }
          { value: 'hoge', label: 'ほげ' }
        ]
      }      
    ]
  },
  {
    name: 'name'
    type: 'text'
    title: '企画名'
    note: '企画の名前をなんたら'
  },
  {
    name: 'desc'
    type: 'paragraph'
    title: '企画概要'
    note: 'なんたら'
    rows: 10
  },
  {
    name: 'select1'
    type: 'multicheck'
    title: '選べ'
    note: '適当に選ぶ'

    choices: [
      { value: 'val1', label: 'その1' }
      { value: 'val2', label: 'その2' }
    ]
  },
  {
    name: 'select2'
    type: 'radio'
    title: '選べ'
    note: 'ひとつ選ぶ'

    choices: [
      { value: 'val1', label: 'その1' }
      { value: 'val2', label: 'その2' }
    ]
  },
  {
    name: 'select3'
    type: 'select'
    title: '選べ'
    note: 'ひとつ選ぶ'

    choices: [
      { value: 'val1', label: 'その1' }
      { value: 'val2', label: 'その2' }
      { value: 'val3', label: 'その3' }
    ]
  }
]

$ ->
  #json = JSON.parse($('#json').text())
  json = schema: schema, value: data
  React.render React.createElement(Formaline, schema: json.schema, value: json.value),
    document.getElementById('form-wrapper')
