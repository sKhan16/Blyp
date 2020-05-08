import React from "react";

export default class PersonCard extends React.Component {
    render() {
        const picSize = 150;
        return (
            <div className="card">

                <img
                    src={this.props.imgSrc}
                    height={picSize}
                    width={picSize}
                    style={{ borderRadius: "50%" }}
                    alt={"A photo of " + this.props.name}
                />
                <h3 className="name" width="100%">{this.props.name}</h3>

                <p className="role" width="100%">{this.props.role}</p>

                <p className="email" width="100%">{this.props.email}</p>

                <p className="bio" width="100%">{this.props.quip}</p>

            </div>
        );
    }
}
