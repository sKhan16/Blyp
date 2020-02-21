import React from "react";
import BlypNavBar from "./components/BlypNavBar";
import Headline from "./components/Headline";
import Support from "./components/Support";
import Screenshots from "./components/Screenshots";
import "./App.css";
import { Container, Row, Col } from "react-bootstrap";
import Team from "./components/Team";

function App() {
  const maxWidth = "1080px";
  return (
    <div className="App text-left">
      <BlypNavBar></BlypNavBar>
      <Container fluid>
        <Row className="justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8} style={{ maxWidth: maxWidth }}>
            <Headline />
          </Col>
        </Row>
        <Row className="justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8} style={{ maxWidth: maxWidth }}>
            <Screenshots images={["", "", "", ""]} />
          </Col>
        </Row>
        <Row className="justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8} style={{ maxWidth: maxWidth }}>
            <Support />
          </Col>
        </Row>
        <Row className="justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8} style={{ maxWidth: maxWidth }}>
            <Team></Team>
          </Col>
        </Row>
      </Container>

      <footer className="footer mt-auto py-3 bg-dark">
          <a href="https://ischool.uw.edu/capstone" className="text-white ml-3">
            This project is a part of the Capstone Project course at the University of Washington Information School
          </a>
      </footer>
    </div>
  );
}

export default App;
