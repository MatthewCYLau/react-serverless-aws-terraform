import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { PageHeader } from "antd";
import { Card, Button, Input } from "antd";
import "antd/dist/antd.css";
import { Layout, Spin } from "antd";
import axios from "axios";

const { Content } = Layout;

const HomePage = () => {
  const loadingState = false;
  const [todos, setTodos] = useState([]);
  const [loadingComplete, setloadingComplete] = useState(loadingState);
  const initialFormState = { name: "", description: "" };
  const [formState, setFormState] = useState(initialFormState);
  const apiEndpoint =
    "https://ymvbz0v6f2.execute-api.us-east-1.amazonaws.com/test/todos";

  useEffect(() => {
    fetchTodos();
  }, []);

  function setInput(key, value) {
    setFormState({ ...formState, [key]: value });
  }

  async function fetchTodos() {
    try {
      const res = await axios.get(apiEndpoint);
      setTodos(res.data.Items);
      setloadingComplete({ loadingComplete: true });
    } catch (err) {
      console.log("error fetching todos");
    }
  }

  async function addTodo() {
    try {
      if (!formState.name || !formState.description) return;
      const todo = { ...formState };
      setTodos([...todos, todo]);
      setFormState(initialFormState);

      const config = {
        headers: {
          "Content-Type": "application/json"
        }
      };
      const body = JSON.stringify(todo);
      await axios.post(apiEndpoint, body, config);
      fetchTodos();
    } catch (err) {
      console.log("error creating todo:", err);
    }
  }

  return (
    <div>
      <Content style={{ padding: "0 50px" }}>
        <div className="site-layout-content">
          <PageHeader
            className="site-page-header"
            title={"Welcome"}
            subTitle="To-do list powered by AWS serverless architecture"
            style={styles.header}
          />
        </div>
        <div>
          <Input
            onChange={event => setInput("name", event.target.value)}
            value={formState.name}
            placeholder="Name"
            style={styles.input}
          />
          <Input
            onChange={event => setInput("description", event.target.value)}
            value={formState.description}
            placeholder="Description"
            style={styles.input}
          />
          <Button onClick={addTodo} type="primary" style={styles.submit}>
            Add
          </Button>
        </div>
        {loadingComplete ? (
          <div>
            {todos.map((todo, index) => (
              <Card
                key={todo.id ? todo.id.S : index}
                title={todo.name.S ? todo.name.S : todo.name}
                style={{ width: 300 }}
              >
                <p>
                  {todo.description.S ? todo.description.S : todo.description}
                </p>
              </Card>
            ))}
          </div>
        ) : (
          <Spin />
        )}
      </Content>
    </div>
  );
};

const styles = {
  input: {
    margin: "10px 0"
  },
  submit: {
    margin: "10px 0",
    marginBottom: "20px"
  },
  header: {
    paddingLeft: "0px"
  }
};

export default HomePage;
