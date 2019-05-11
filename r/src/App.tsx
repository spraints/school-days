import React from 'react';
import './App.css';
import Inputs from './Inputs';
import Calendar from './Calendar';
import {MonthData} from './Types';
import generateCalendar from './generate-calendar';

type Props = any
type State = {
  calendar: Array<MonthData>
}

class App extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {calendar: generateCalendar()};
  }

  render() {
    return (
      <div className="container">
        <div className="jumbotron">
          <h1 className="display-4">School Days</h1>
          <div className="container">
            <Inputs/>
          </div>
        </div>
        <Calendar months={this.state.calendar}/>
      </div>
    );
  }
}

export default App;
