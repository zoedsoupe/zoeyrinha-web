defmodule ZoeyrinhaWeb.CardHTML do
  use ZoeyrinhaWeb, :html

  def show(assigns) do
    ~H"""
    <style>
      .card {
              background-color: #2a2a2a;
              border-radius: 10px;
              box-shadow: 0 4px 8px rgba(255, 255, 255, 0.1);
              padding: 30px;
              width: 300px;
              text-align: center;
          }
          .profile-img {
              width: 120px;
              height: 120px;
              border-radius: 50%;
              margin: 0 auto 20px;
              display: block;
          }

          .profile-img img {
              max-width: 100px;
              max-height: 100px;
              border-radius: 50%;
          }
          h1 {
              color: #e066ff;
              margin-bottom: 10px;
          }
          p {
              color: #d0d0d0;
              margin-bottom: 20px;
          }
          .contact-list {
              list-style-type: none;
              padding: 0;
              text-align: left;
          }
          .contact-list li {
              margin-bottom: 10px;
              display: flex;
              align-items: center;
          }
          .contact-list li i {
              margin-right: 10px;
              color: #e066ff;
          }
          a {
              color: #e066ff;
              text-decoration: none;
              transition: color 0.3s ease;
          }
          a:hover {
              color: #ff99ff;
          }
          .footer {
              margin-top: 20px;
              font-size: 0.8em;
              color: #999;
          }
    </style>
    <main class="card">
      <div class="profile-img">
        <img src={~p"/images/profile.jpeg"} alt="Foto da Lain, do anime Serial Experiments Lain" />
      </div>
      <h1>zoedsoupe</h1>
      <p>Desenvolvedora Especialista | Entusiasta Funcional | Gótica Tech</p>
      <ul class="contact-list">
        <li><i>📧</i> <a href="mailto:zoey.spessanha@zeetech.io">zoey.spessanha@zeetech.io</a></li>
        <li><i>💼</i> <a href="https://linkedin.com/in/zoedsoupe" target="_blank">LinkedIn</a></li>
        <li><i>🐙</i> <a href="https://github.com/zoedsoupe" target="_blank">GitHub</a></li>
        <li><i>✍️</i> <a href="https://dev.to/zoedsoupe" target="_blank">Dev.to</a></li>
        <li>
          <i>🦋</i><a href="https://bsky.app/profile/zoedsoupe.zeetech.io" target="_blank">BlueSky</a>
        </li>
      </ul>
      <p class="footer">"Transformando café em código e bugs em features desde 2017"</p>
    </main>
    """
  end
end
