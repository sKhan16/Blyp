import React, { Component } from "react";

export default class SupportLink extends React.Component {
    render() {
        return (
            <div className="support-link">
                <h3 className="support-title">{this.props.title}</h3>

                <p>{this.props.details}</p>

                <div >
                    <a className="button" href={this.props.buttonHref}>{this.props.buttonName}</a>
                </div>
            </div>
        );
    }
}
