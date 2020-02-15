import React from "react";
import logo from "./logo.svg";
import BlypNavBar from "./components/BlypNavBar";
import Headline from "./components/Headline";
import Support from "./components/Support";
import "./App.css";
import { Container, Row, Col } from "react-bootstrap";

function App() {
  return (
    <div className="App text-left">
      <BlypNavBar></BlypNavBar>
      <Container fluid>
        <Row className="justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8}>
            <Headline />
          </Col>
        </Row>
        <Row className="justify-content-center">
          <Col xs={12} sm={12} md={10} lg={8} xl={8}>
            <Support />
          </Col>
        </Row>
      </Container>
    </div>
  );
}

export default App;
