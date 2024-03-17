import React, { useState } from 'react';
import axios from 'axios';

function App() {
  const [message1, setMessage1] = useState('');
  const [message2, setMessage2] = useState('');

  const handleClick1 = async () => {
    try {
      const response = await axios.get(`${process.env.REACT_APP_API_BASE_URL}/hello`);
      setMessage1(response.data.message);
    } catch (error) {
      console.error('Error:', error);
      setMessage1('Failed to fetch message from API 1');
    }
  };

  const handleClick2 = async () => {
    try {
      const response = await axios.get(`${process.env.REACT_APP_API_BASE_URL}/world`);
      setMessage2(response.data.message);
    } catch (error) {
      console.error('Error:', error);
      setMessage2('Failed to fetch message from API 2');
    }
  };

  return (
    <div>
      <h1>React App</h1>
      <button onClick={handleClick1}>Say Hello</button>
      <p>{message1}</p>
      <button onClick={handleClick2}>Say World</button>
      <p>{message2}</p>
    </div>
  );
}

export default App;