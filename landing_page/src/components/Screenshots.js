import React from "react";
import { Container, Col, Row } from "react-bootstrap";
import iPhone from "../img/iPhone.png";
import TemporaryScreenshot from "../img/screenshot.png";

export default class Screenshots extends React.Component {
  render() {
    let rows = [];
    for (let image of this.props.images) {
      rows.push(
        <Col xs={12} sm={6} md={6} lg={3} xl={3}>
          <div style={{position: "relative", height:"300px"}}>
            <img height="300px" src={iPhone} style={{ position: "absolute", display: "block", margin: "auto", zIndex: "3" }}></img>
            <img
              height="275px"
              src={TemporaryScreenshot}
              style={{ position: "absolute", display: "block", margin: "auto", zIndex: "2", top:"13px", left:"14px" }}
            ></img>
          </div>
        </Col>
      );
    }

    return (
      <Container>
        <Row>{rows}</Row>
      </Container>
    );
  }
}
