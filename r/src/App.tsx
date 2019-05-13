import React from 'react';
import './App.css';
import Inputs from './Inputs';
import Calendar from './Calendar';
import {CalendarMonth, Month} from './Types';
import generateCalendar from './generate-calendar';

type Skip = {
  month: Month
  day: number
}

type Props = {}
type State = {
  calendar: Array<CalendarMonth>
  skips: Array<Skip>
  requiredDays: number
  completedDays: number
}

class App extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      calendar: generateCalendar(new Date()),
      skips: [],
      requiredDays: 180,
      completedDays: 0
    };
  }

  setRequiredDays(n: number) {
    this.setState({requiredDays: n})
  }

  setCompletedDays(n: number) {
    this.setState({completedDays: n})
  }

  onSkip(days: Array<Date>) {
    const newSkips = days.map(day => ({
      month: day.getMonth() as Month,
      day: day.getDate()
    }))
    this.setState({skips: this.state.skips.concat(newSkips)})
  }

  onUnskip(days: Array<Date>) {
    let skips = this.state.skips
    for (const day of days) {
      skips = skips.filter(skip => skip.month !== day.getMonth() || skip.day !== day.getDate())
    }
    this.setState({skips})
  }

  render() {
    console.log(this.state.skips)
    const actions = {
      skip: this.onSkip.bind(this),
      unskip: this.onUnskip.bind(this),
      setCompletedDays: this.setCompletedDays.bind(this),
      setRequiredDays: this.setRequiredDays.bind(this)
    }
    return (
      <div className="container">
        <div className="jumbotron">
          <h1 className="display-4">School Days</h1>
          <div className="container">
            <Inputs completedDays={this.state.completedDays} requiredDays={this.state.requiredDays} actions={actions} />
          </div>
        </div>
        <Calendar months={this.state.calendar} actions={actions} />
      </div>
    );
  }
}

export default App;
