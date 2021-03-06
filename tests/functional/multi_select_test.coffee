content = [
  {name: 'Alice', code: 'ALICE'},
  {name: 'Bob', code: 'BOB'},
]

multiSelect = null

moduleForComponent 'multi-select', '[Functional] Multi select component',
  needs: [
    'template:multi-select'
    'template:multi-select-item'
    'template:select-item-layout'
    'template:select-item'
  ]
  teardown: ->
    Ember.run ->
      multiSelect.destroy()
    multiSelect = null

test "Multi select component has correct CSS classes", ->
  multiSelect = @subject
    classNames: 'some-class-name'

  deepEqual multiSelect.get("classNames"), [
    "ember-view"
    "ember-select"
    "some-class-name"
  ]


test "Can add item via click", ->
  expect 2

  multiSelect = @subject
    content: content
    optionLabelPath: 'name'
    optionValuePath: 'code'
    classNames: 'some-class-name'

  @append()
  $multiSelect = find('.some-class-name')
  selectInMultiChosen($multiSelect, 'Alice').then ->
    $multiSelect = find('.some-class-name')
    equal $multiSelect.find('.ember-select-search-choice').length, 1, "one item is now selected"
    ok $multiSelect.find('.ember-select-search-choice').text().indexOf('Alice') >= 0, "Alice was selected"


test "Invalid item cannot be selected", ->
  expect 2

  multiSelect = @subject
    content: content
    optionLabelPath: 'name'
    optionValuePath: 'code'
    classNames: 'some-class-name'

  @append()
  $multiSelect = find('.some-class-name')
  userDidSelectStub = sinon.stub multiSelect, 'userDidSelect'
  item = findInMultiChosen($multiSelect, 'textThatWontMatch')
  .then (item) ->
    ok isNotPresent(item), 'List item was matched unexpectedly'
    enterEvent = Ember.$.Event('keyPressed', keyCode: 13)
    multiSelect.enterPressed(enterEvent)
  .then ->
    equal userDidSelectStub.callCount, 0, "userDidSelect should not have been called, but was called " + userDidSelectStub.callCount


test "Valid item can be selected via enter", ->
  expect 2

  multiSelect = @subject
    content: content
    optionLabelPath: 'name'
    optionValuePath: 'code'
    classNames: 'some-class-name'

  @append()
  $multiSelect = find('.some-class-name')
  userDidSelectStub = sinon.stub multiSelect, 'userDidSelect'
  item = findInMultiChosen($multiSelect, 'Alice')
  .then (item) ->
    ok isPresent(item), 'List item was not matched'
    enterEvent = Ember.$.Event('keyPressed', keyCode: 13)
    multiSelect.enterPressed(enterEvent)
  .then ->
    equal userDidSelectStub.callCount, 1, "userDidSelect should have been called once, but was called " + userDidSelectStub.callCount
