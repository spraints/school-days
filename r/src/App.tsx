import React from 'react';
import './App.css';
import Inputs from './Inputs';
import Calendar from './Calendar';
import {MonthData, MonthDay} from './Types';
import generateCalendar from './generate-calendar';

type Props = any
type State = {
  calendar: Array<MonthData>
  requiredDays: number
  completedDays: number
}

class App extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      calendar: generateCalendar(new Date()),
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

  onSkip(days: Array<MonthDay>) {
    this.updateSkips(true, days)
  }

  onUnskip(days: Array<MonthDay>) {
    this.updateSkips(false, days)
  }

  updateSkips(newValue: boolean, days: Array<MonthDay>) {
    const matcher = this.makeMatcher(days)
    const calendar = this.state.calendar.map(md => ({
      month: md.month,
      weeks: md.weeks.map(wd => wd.map(dd => (dd && {
        day: dd.day,
        dow: dd.dow,
        skipped: matcher(md.month, dd.day) ? newValue : dd.skipped
      })))
    }))
    this.setState({calendar})
  }

  makeMatcher(days: Array<MonthDay>): (month: string, day: number) => boolean {
    const hits: {[month: string]: {[day: number]: boolean}} = {}
    days.forEach(day => {
      if (!hits[day.month])
        hits[day.month] = {}
      hits[day.month][day.day] = true
    })
    return (month: string, day: number) => (hits[month] && hits[month][day]) || false
  }

  render() {
    const actions = {
      onSkip: this.onSkip.bind(this),
      onUnskip: this.onUnskip.bind(this),
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
