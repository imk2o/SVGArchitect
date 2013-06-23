class Inspector
  constructor: ($div, @$element, clear) ->
    if clear?
      $div.empty()
    @$table = $('<table class="inspector" width="100%"></table>').appendTo($div)

  addField: (label, field) ->
    $tr = $('<tr />').appendTo(@$table)
    if label?
      $row = $th = $('<th />').append(label).appendTo($tr)
    if field?
      $row = $td = $('<td />').append(field).appendTo($tr)

    unless $th? && $td?
      $row.attr('colspan', '2')

  addSection: (label) ->
    @addField(label)

  addInnerTextField: (label) ->
    field = "<textarea id=\"inner-text\" class=\"text\" />"
    @addField(label, field)

    # bind
    element = @$element
    $("#inner-text")
      .val(element.text())
      .change -> element.text($(this).val())

  addTextField: (id, label, option) ->
    if option?.rows? > 1
      field = "<textarea id=\"#{id}\" class=\"text\" rows=\"#{option.rows}\" />"
    else
      field = "<input id=\"#{id}\" class=\"text\" type=\"text\"></input>"
    @addField(label, field)
    bindText(@$element, id, option)

  addColorPicker: (id, label) ->
    field = "<input id=\"#{id}\" class=\"color\" type=\"text\">"
    @addField(label, field)
    bindColor(@$element, id)

  addSlider: (id, label, option) ->
    id_for_tf = "#{id}_text"
    field = "<div id=\"#{id}\" class=\"slider\" style=\"float: left; width: 60%;\" /><input id=\"#{id_for_tf}\" type=\"text\" style=\"width: 4em;\" />"
    @addField(label, field)
    bindSlider(@$element, id, option)
    bindText(@$element, id_for_tf, {attr: id})

  addSelector: (id, label, items) ->
    $select = $("<select id=\"#{id}\" class=\"selector\">")
    for item in items
      $("<option value=\"#{item}\">#{item}</option>").appendTo($select)
    @addField(label, $select[0])

    # bind
    element = @$element
    $("##{id}")
      .val(element.attr(id))
      .change -> element.attr(id, $(this).val())

  addFileSelector: (id, label, attr) ->
    attr ?= id
    field = "<input id=\"#{id}\" type=\"file\"></input>"
    @addField(label, field)

    # bind
    element = @$element
    $("##{id}")
      .change (e) ->
        reader = new FileReader()
        reader.onload = (f) ->
          #element.attr(attr, f.target.result)
          element[0].setAttributeNS('http://www.w3.org/1999/xlink', attr, f.target.result)
        reader.readAsDataURL(e.target.files[0])

currentElement$ = ->
  node = $('#svg_tree').dynatree('getActiveNode')
  return $(node.data.element)

bindText = (element, id, option = {}) ->
  option.attr ?= id

  $("##{id}")
    .val(element.attr(option.attr))
    .change -> element.attr(option.attr, $(this).val())

bindColor = (element, id, attr) ->
  attr ?= id

  $('#' + id)
    .val(element.attr(attr))
    .change(-> element.attr(attr, $(this).val()))
    .modcoder_excolor({callback_on_ok: -> element.attr(attr, $('#' + id).val())})

bindSlider = (element, id, option = {}) ->
  option.attr ?= id
  option.min ?= 0.0
  option.max ?= 1.0
  option.step ?= 0.01

  $('#' + id)
    .slider({min: option.min, max: option.max, step: option.step})
    .slider('value', element.attr(option.attr))
    .slider({change: (e, ui) -> element.attr(option.attr, ui.value)})

bindTranslate = ($container, svg_tr) ->
  # matrix を変更すると type が変わってしまうので、setTranslate() を使う
  $('#x', $container)
    .val(svg_tr.matrix.e)
    .change -> svg_tr.setTranslate($(this).val(), svg_tr.matrix.f)

  $('#y', $container)
    .val(svg_tr.matrix.f)
    .change -> svg_tr.setTranslate(svg_tr.matrix.e, $(this).val())

bindRotate = ($container, svg_tr) ->
  # angle は readonly っぽいので、setRotate() を使う
  $('#angle', $container)
    .val(svg_tr.angle)
    .change -> svg_tr.setRotate($(this).val(), 0, 0)

bindScale = ($container, svg_tr) ->
  # matrix を変更すると type が変わってしまうので、setScale() を使う
  $('#x', $container)
    .val(svg_tr.matrix.a)
    .change -> svg_tr.setScale($(this).val(), svg_tr.matrix.d)

  $('#y', $container)
    .val(svg_tr.matrix.d)
    .change -> svg_tr.setScale(svg_tr.matrix.a, $(this).val())

createRow = (table$, label, content) ->
  tr$ = $('<tr />').appendTo(table$)
  $('<th />').append(label).appendTo(tr$)
  return $('<td />').append(content).appendTo(tr$)

@inspectCurrentElement = (properties) ->
  element$ = currentElement$()
  e = element$[0]

  inner_text_presented = false
  presented_attrs = {}
  inspector = new Inspector($('#properties'), element$, true)
  for property in properties
    if property.attr?
      presented_attrs[property.attr] = true
    else
      presented_attrs[property.id] = true

    switch property.field
      when 'section' then inspector.addSection(property.label)
      when 'text' then inspector.addTextField(property.id, property.label, property.option)
      when 'color' then inspector.addColorPicker(property.id, property.label)
      when 'slider' then inspector.addSlider(property.id, property.label, property.option)
      when 'selector' then inspector.addSelector(property.id, property.label, property.items)
      when 'inner-text'
        inspector.addInnerTextField(property.label)
        inner_text_presented = true
      when 'file' then inspector.addFileSelector(property.id, property.label, property.attr)

  createTranslateInspector = (tr) ->
    label = 'Translate'
    content = 'X: <input id="x" type="text"></input> Y: <input id="y" type="text"></input>'
    $container = createRow($('#transforms table'), label, content)
    bindTranslate($container, tr)

  createScaleInspector = (tr) ->
    label = 'Scale'
    content = 'X: <input id="x" type="text"></input> Y: <input id="y" type="text"></input>'
    $container = createRow($('#transforms table'), label, content)
    bindScale($container, tr)

  createRotateInspector = (tr) ->
    label = 'Rotate'
    content = 'Angle: <input id="angle" type="text"></input>'
    $container = createRow($('#transforms table'), label, content)
    bindRotate($container, tr)

  transform_inspector = new Inspector($('#transforms'), element$, true)
  e_tr = e.transform || e.gradientTransform
  if e_tr
    transform_inspector.addSection('Transforms')
    trs = e_tr.baseVal
    if trs.numberOfItems
      for i in [0..trs.numberOfItems - 1]
        tr = trs.getItem(i)
        switch tr.type
          when 2 then createTranslateInspector(tr)
          when 3 then createScaleInspector(tr)
          when 4 then createRotateInspector(tr)

    $('<button>Add Translate</button>').appendTo('#transforms').click ->
      e = element$[0]
      tr = e.ownerSVGElement.createSVGTransform()
      tr.setTranslate(0, 0)
      createTranslateInspector(tr)
      e_tr.baseVal.appendItem(tr)
    $('<button>Add Rotate</button>').appendTo('#transforms').click ->
      e = element$[0]
      tr = e.ownerSVGElement.createSVGTransform()
      tr.setRotate(0, 0, 0)
      createRotateInspector(tr)
      e_tr.baseVal.appendItem(tr)
    $('<button>Add Scale</button>').appendTo('#transforms').click ->
      e = element$[0]
      tr = e.ownerSVGElement.createSVGTransform()
      tr.setScale(1, 1)
      createScaleInspector(tr)
      e_tr.baseVal.appendItem(tr)

  other_inspector = new Inspector($('#others'), element$, true)
  unless inner_text_presented
    other_inspector.addSection('Inner Text')
    other_inspector.addInnerTextField()
  if e.attributes.length > 0
    other_inspector.addSection('Other Attributes')
    for i in [0..(e.attributes.length - 1)]
      attr_name = e.attributes[i].name
      if presented_attrs[attr_name]
        continue
      id = attr_name.replace(':', '-')    # namespace セパレータを回避
      label = attr_name
      other_inspector.addTextField(id, label, {attr: attr_name})

#$(inspectCurrentElement())
