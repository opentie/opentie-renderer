React = require 'react'
cfx = require 'coffeex'
Entities = require('html-entities').AllHtmlEntities
entities = new Entities()

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
        disabled: @props.readonly
        type: 'text'
        name: @schema.nestedName
        defaultValue: @props.value
        placeholder: @schema.placeholder

class ParagraphInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.textarea '.form-control',
        disabled: @props.readonly
        rows: (@schema.rows or 3)
        name: @schema.nestedName
        defaultValue: @props.value
        placeholder: @schema.placeholder

class MultiCheckInput extends Input
  isSelected: (value) ->
    return false unless Array.isArray(@props.value)
    (@props.value || []).indexOf(value) isnt -1
    
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      for choice in @schema.choices
        $.div '.checkbox', ->
          $.label ->
            $.input
              disabled: @props.readonly
              name: "#{@schema.nestedName}[]"
              type: 'checkbox'
              value: choice.value
              defaultChecked: @isSelected(choice.value)
            _ if choice.label? then choice.label else choice.value

class RadioInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      for choice in @schema.choices
        $.div '.radio', ->
          $.label ->
            $.input
              disabled: @props.readonly
              name: "#{@schema.nestedName}"
              type: 'radio'
              value: choice.value
              defaultChecked: choice.value is @props.value
            _ if choice.label? then choice.label else choice.value

class SelectInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.select '.form-control',
        name: @schema.nestedName
        defaultValue: @props.value, ->
          for choice in @schema.choices
            $.option
              disabled: @props.readonly
              value: choice.value,
              if choice.label? then choice.label else choice.value

class NumberInput extends Input
  template: cfx ($, _) ->
    $.div '.form-group', ->
      $.label @schema.title
      $.p @schema.note
      $.input '.form-control',
        disabled: @props.readonly
        type: 'number'
        name: @schema.nestedName
        defaultValue: @props.value
        placeholder: @schema.placeholder

class Formalizr extends React.Component
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
    $.form '.fromalizr',
      method: 'POST'
      action: (@props.action || '.'), ->
        $.input
          type: 'hidden'
          name: '_method'
          value: (@props.method || 'POST')
        $.input
          type: 'hidden'
          name: 'authenticity_token'
          value: @props.authenticityToken
        for child, i in @props.schema
          nestedName = "formalizr[#{child.name}]"
          $ @switchInput(child),
            readonly: @props.readonly
            schema: Object.create(child, nestedName: { value: nestedName })
            value: @props.value[child.name]
        unless @props.readonly
          $.hr
          $.div '.text-right', ->
            $.button '.btn.btn-primary.btn-lg', (@props.submit || '提出')

  render: -> @template this

class TableCellInput extends Input
  handleChange: ->
    @props.onChange.apply null, arguments

class TableTextInput extends TableCellInput
  template: cfx ($, _) ->
    $.input '.form-control',
      disabled: @props.readonly
      type: 'text'
      name: @schema.nestedName
      defaultValue: @props.value
      placeholder: @schema.placeholder
      onChange: @handleChange.bind(this)

class TableNumberInput extends TableCellInput
  template: cfx ($, _) ->
    $.input '.form-control',
      disabled: @props.readonly
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
            disabled: @props.readonly
            value: choice.value,
            choice.label

class TableInput extends Input
  constructor: (props) ->
    super props
    @state =
      value: (@props.value || []).map (row) ->
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
        for column in @schema.columns
          if column.note?
            $.dt column.title
            $.dd column.note
      $.table '.table', ->
        $.tbody ->
          $.tr key: 'header', ->
            $.th '.text-right', '#'
            for column in @schema.columns
              $.th column.title
            unless @props.readonly
              $.th '削除'
          values = @state.value
          if @props.readonly
            values = if values.length > 0 then values else [{}]
          for value, i in values
            $.tr key: value._key, ->
              $.th '.text-right', "#{i+1}"
              for column in @schema.columns
                $.td key: column.name, ->
                  nestedName = "#{@schema.nestedName}[][#{column.name}]"
                  $ @switchInput(column),
                    readonly: @props.readonly
                    schema: Object.create(column, nestedName: { value: nestedName })
                    value: value[column.name]
                    onChange: @handleChange.bind(this, i, column.name)
              unless @props.readonly
                $.td ->
                  $.button '.btn.btn-danger',
                    type: 'button',
                    onClick: @removeRow.bind(this, i), ->
                      $.span '.glyphicon.glyphicon-remove', ariaHidden: true
          unless @props.readonly
            $.tr key: 'footer', ->
              $.td '.text-center', colSpan: @schema.columns.length+2, ->
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
    for column in @schema.columns
      initialValue[column.name] = column.default
      initialValue._key = inc()

    @setState {
      value: @state.value.concat([initialValue])
    }

$ ->
  jsonElem = $('#form-wrapper > script')
  return if jsonElem.size() is 0
  json = JSON.parse(entities.decode(jsonElem.text()))
  React.render React.createElement(Formalizr, json),
    document.getElementById('form-wrapper')
