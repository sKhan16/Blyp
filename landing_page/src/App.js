import React from "react";
import BlypNavBar from "./components/BlypNavBar";
import Headline from "./components/Headline";
import Support from "./components/Support";
import Purpose from "./components/Purpose";
import Screenshots from "./components/Screenshots";
import "./App.css";
import { Container, Row, Col } from "react-bootstrap";
import Team from "./components/Team";

function App() {
  return (
    <div className="App text-left">
      <BlypNavBar></BlypNavBar>
      <div className="app-container">
        <Row className="main section justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8} >
            <Headline />
          </Col>
        </Row>
        
        <Row className="section justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8}>
            <Purpose />
          </Col>
        </Row>

        {/* <Row className="justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8} style={{ maxWidth: maxWidth }}>
            <Screenshots images={["", "", "", ""]} />
          </Col>
        </Row> */}
        <Row className="section justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8}>
            <Support />
          </Col>
        </Row>
        <Row className="section justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8}>
            <Team></Team>
          </Col>
        </Row>
      </div>

      <footer className="footer mt-auto py-3 bg-light">
          <a href="https://ischool.uw.edu/capstone" className="link ml-3">
            This project is a part of the Capstone Project course at the University of Washington Information School
          </a>
      </footer>
    </div>
  );
}

export default App;
