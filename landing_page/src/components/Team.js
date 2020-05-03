import React from "react";
import { Jumbotron, Row, Container } from "react-bootstrap";
import PersonCard from "./PersonCard";

import gravatar from "../img/gravatar.png";
import kassy from "../img/k.jpg"
import hayden from "../img/h.jpg"
import shakeel from "../img/s.jpg"
import vanely from '../img/v.jpg'

export default class Team extends React.Component {
  render() {
    return (
      <div className="text-left pt-0 pb-0">
        <h2 className="header display-4 font-weight-bold">our team</h2>
        <Container>
          <Row>
            <PersonCard
              imgSrc={hayden}
              name="Hayden Hong"
              role="iOS Developer"
              email="hello@haydenhong.com"
              quip="Hello world!"
            ></PersonCard>
            <PersonCard
              imgSrc={vanely}
              name="Vanely Ruiz"
              role="Designer & Developer"
              email="vanely@uw.edu"
              quip="Hello world!"
            ></PersonCard>
            <PersonCard
              imgSrc={shakeel}
              name="Shakeel Khan"
              role="Full Stack Developer"
              email="khansk97@uw.edu"
              quip="Hello world!"
            ></PersonCard>
            <PersonCard
              imgSrc={kassy}
              name="Kassandra Franco"
              role="PM & Designer"
              email="kfranco@uw.edu"
              quip="Hello world!"
            ></PersonCard>
          </Row>
        </Container>
      </div>
    );
  }
}
