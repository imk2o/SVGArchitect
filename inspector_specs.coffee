@inspector_specs = {
  rect:
    [{field: 'section', label: 'Geometry'},
    {field: 'text', id: 'x', label: 'X'},
    {field: 'text', id: 'y', label: 'Y'},
    {field: 'text', id: 'width', label: 'Width'},
    {field: 'text', id: 'height', label: 'Height'},
    {field: 'section', label: 'Stroke'},
    {field: 'color', id: 'stroke', label: 'Color'},
    {field: 'slider', id: 'stroke-width', label: 'Width', option: {min: 1, max: 10, step: 1}},
    {field: 'section', label: 'Fill'},
    {field: 'color', id: 'fill', label: 'Color'},
    {field: 'slider', id: 'opacity', label: 'Opacity'}]
  circle:
    [{field: 'section', label: 'Geometry'},
    {field: 'text', id: 'cx', label: 'X'},
    {field: 'text', id: 'cy', label: 'Y'},
    {field: 'text', id: 'r', label: 'Radius'},
    {field: 'section', label: 'Stroke'},
    {field: 'color', id: 'stroke', label: 'Color'},
    {field: 'slider', id: 'stroke-width', label: 'Width', option: {min: 1, max: 10, step: 1}},
    {field: 'section', label: 'Fill'},
    {field: 'color', id: 'fill', label: 'Color'},
    {field: 'slider', id: 'opacity', label: 'Opacity'}]
  text:
    [{field: 'section', label: 'Geometry'},
    {field: 'text', id: 'x', label: 'X'},
    {field: 'text', id: 'y', label: 'Y'},
    {field: 'section', label: 'Text'},
    {field: 'inner-text', label: 'Text'},
    {field: 'section', label: 'Font'},
    {field: 'text', id: 'font-family', label: 'Family'},
    {field: 'text', id: 'font-size', label: 'Size'},
    {field: 'section', label: 'Stroke'},
    {field: 'color', id: 'stroke', label: 'Color'},
    {field: 'slider', id: 'stroke-width', label: 'Width', option: {min: 1, max: 10, step: 1}},
    {field: 'section', label: 'Fill'},
    {field: 'color', id: 'fill', label: 'Color'},
    {field: 'slider', id: 'opacity', label: 'Opacity'}]
  path:
    [{field: 'section', label: 'Geometry'},
    {field: 'text', id: 'd', option:{rows: 4}},
    {field: 'section', label: 'Stroke'},
    {field: 'color', id: 'stroke', label: 'Color'},
    {field: 'slider', id: 'stroke-width', label: 'Width', option: {min: 1, max: 10, step: 1}},
    {field: 'section', label: 'Fill'},
    {field: 'color', id: 'fill', label: 'Color'},
    {field: 'slider', id: 'opacity', label: 'Opacity'}]
  image:
    [{field: 'section', label: 'Geometry'},
    {field: 'text', id: 'x', label: 'X'},
    {field: 'text', id: 'y', label: 'Y'},
    {field: 'text', id: 'width', label: 'Width'},
    {field: 'text', id: 'height', label: 'Height'},
    {field: 'section', label: 'Src'},
    {field: 'file', id: 'href', label: 'URL'},
    {field: 'section', label: 'Fill'},
    {field: 'slider', id: 'opacity', label: 'Opacity'}]
  g:
    [{field: 'section', label: 'Stroke'},
    {field: 'color', id: 'stroke', label: 'Color'},
    {field: 'slider', id: 'stroke-width', label: 'Width', option: {min: 1, max: 10, step: 1}},
    {field: 'section', label: 'Fill'},
    {field: 'color', id: 'fill', label: 'Color'},
    {field: 'slider', id: 'opacity', label: 'Opacity'}]
  stop:
    [{field: 'slider', id: 'offset', label: 'Offset'},
    {field: 'color', id: 'stop-color', label: 'Color'},
    {field: 'slider', id: 'stop-opacity', label: 'Opacity'}]
}
