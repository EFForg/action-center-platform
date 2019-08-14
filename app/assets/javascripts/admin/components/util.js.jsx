
function Conditional(props) {
  if (props.when)
    return props.children;
  else
    return null;
}


function Icon(props) {
  return <span className={ "glyphicon glyphicon-" + props.name } />;
}

var EditableText = React.createClass({
  getInitialState: function() {
    return { value: this.props.value };
  },

  updateValue: function(e) {
    this.setState({ value: e.target.value });
  },

  select: function() {
    this.refs.input.select();
  },

  value: function() {
    return this.state.value;
  },

  reset: function() {
    this.setState({ value: "" });
  },

  render: function() {
    if (this.props.editMode)
      return <input ref="input" onChange={ this.updateValue }
                    name={ this.props.name } value={ this.state.value }
                    placeholder={ this.props.placeholder } />;
    else
      return <span>{ this.state.value }</span>;
  }
});
