import React from "react"

export default class Circle extends React.Component {
    render() {
        let diameter = 2 * this.props.radius + "px"
        let radius = this.props.radius + "px"
        return (
            <svg height={diameter} width={diameter}>
                <circle cx={radius} cy={radius} r={radius} fill="gray" />
                <text x="50%" y="50%" text-anchor="middle" font-size="2em" stroke="white" fill="white" dy=".3em">{this.props.text}</text>
            </svg>
        )
    }
}