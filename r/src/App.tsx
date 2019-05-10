import React from 'react';
import './App.css';
import Inputs from './Inputs';
import Calendar from './Calendar';

function App() {
  const calendar = [
    {month: "May", weeks: [
      [
        null,
        null,
        null,
        {day: 1, skipped: false},
        {day: 2, skipped: false},
        {day: 3, skipped: false},
        {day: 4, skipped: false},
      ],
      [
        {day: 5, skipped: false},
        {day: 6, skipped: false},
        {day: 7, skipped: false},
        {day: 8, skipped: false},
        {day: 9, skipped: false},
        {day: 10, skipped: false},
        {day: 11, skipped: false},
      ],
      [
        {day: 12, skipped: false},
        {day: 13, skipped: false},
        {day: 14, skipped: true},
        {day: 15, skipped: false},
        {day: 16, skipped: false},
        {day: 17, skipped: false},
        {day: 18, skipped: false},
      ],
    ]}
  ]

  return (
    <div className="container">
      <Inputs/>
      <Calendar months={calendar}/>
    </div>
  );
}

export default App;
