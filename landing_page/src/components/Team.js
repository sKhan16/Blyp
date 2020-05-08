import React from "react";
import PersonCard from "./PersonCard";
import kassy from "../img/k.jpg"
import hayden from "../img/h.jpg"
import shakeel from "../img/s.jpg"
import vanely from '../img/v.jpg'

export default class Team extends React.Component {
    render() {
        return (
            <div id="team" className="section team" name="team">
                <h2 className="">our team</h2>

                <div className="container">
                    <PersonCard
                        imgSrc={hayden}
                        name="Hayden Hong"
                        role="iOS Developer"
                        email="hello@haydenhong.com"
                        quip=""
                    ></PersonCard>

                    <PersonCard
                        imgSrc={vanely}
                        name="Vanely Ruiz"
                        role="Designer & Developer"
                        email="vanely@uw.edu"
                        quip=""
                    ></PersonCard>

                    <PersonCard
                        imgSrc={shakeel}
                        name="Shakeel Khan"
                        role="Full Stack Developer"
                        email="khansk97@uw.edu"
                        quip=""
                    ></PersonCard>

                    <PersonCard
                        imgSrc={kassy}
                        name="Kassandra Franco"
                        role="PM & Designer"
                        email="kfranco@uw.edu"
                        quip=""
                    ></PersonCard>
                </div>
            </div>
        );
    }
}
