import React from "react";
import BlypNavBar from "./components/BlypNavBar";
import Headline from "./components/Headline";
import About from "./components/About";
import Support from "./components/Support";
import Purpose from "./components/Purpose";
import "./App.css";
import Team from "./components/Team";

function App() {
    return (
        <div className="App text-left">
            <BlypNavBar></BlypNavBar>

            <Headline />

            <About />

            <Purpose />

            <Support />

            <Team />

            <footer className="footer">
                <a href="https://ischool.uw.edu/capstone" className="link">
                    This project is a part of the Capstone Project course at the University of Washington Information School
                </a>
            </footer>
        </div>
    );
}

export default App;
