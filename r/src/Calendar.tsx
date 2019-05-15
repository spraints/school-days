import React from 'react';
import Month from './Month';
import {ActionsProps} from './Types';
import {SchoolCalendar} from './school-calendar';

type Props = ActionsProps & {
  months: SchoolCalendar
}

function Calendar(props: Props) {
  return (
    <div className="calendar">
      {props.months.map(month =>
        <Month actions={props.actions} {...month} />
      )}
    </div>
  )
}

export default Calendar;
