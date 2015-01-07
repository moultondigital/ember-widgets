`import Ember from 'ember'`

RadioButtonComponent = Ember.Component.extend
  attributeBindings: ['type', 'checked', 'disabled']
  classNames: ['radio-input']
  tagName: 'input'
  type: 'radio'
  checked: Ember.computed.alias 'parentView.checked'
  disabled: Ember.computed.alias 'parentView._disabled'

`export default RadioButtonComponent`
